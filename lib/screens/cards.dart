import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magicards/screens/card_details.dart';
import 'package:magicards/screens/cards_radial_menu.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardsScreen extends StatefulWidget {
  final Subtopic subtopic;
  CardsScreen({Key key, this.subtopic}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with SingleTickerProviderStateMixin {
  static const kExpandedHeight = 155.0;

  ScrollController _scrollController;
  AnimationController _animatedFABController;

  List<Magicard> listOfCards = List<Magicard>();
  List<String> listLearnedCardsIDs = List<String>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));

    _animatedFABController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 1),
    );
  }

  @override
  dispose() {
    _scrollController.dispose();
    _animatedFABController.dispose();
    super.dispose();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(children: <Widget>[
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('cards')
            .where('subtopic', isEqualTo: widget.subtopic.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            var documents = snapshot.data.documents;
            FirebaseUser user = Provider.of<FirebaseUser>(context);

            if (user != null) {
              return FutureBuilder<List<String>>(
                future: DB.getEarlyLearnedCardsIDs(
                    userId: user.uid, subtopicId: widget.subtopic.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  } else {
                    listLearnedCardsIDs = snapshot.data;
                    return _buildList(context, documents);
                  }
                },
              );
            } else {
              return _buildList(context, documents);
            }
          }
        },
      ),
    ]);
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    listOfCards = snapshot
        .map((document) => Magicard.fromMap(document.documentID, document.data))
        .toList();

    List<Magicard> notLearnedMagicards = List<Magicard>();
    List<Magicard> learnedMagicards = List<Magicard>();
    List<Magicard> listOfCardsSorted = List<Magicard>();

    listOfCards.forEach((card) {
      listLearnedCardsIDs.contains(card.id)
          ? learnedMagicards.add(card)
          : notLearnedMagicards.add(card);
    });

    listOfCardsSorted = notLearnedMagicards + learnedMagicards;

    /*print('notLearnedMagicards = ');
    notLearnedMagicards.forEach((element) {
      print(element.toString());
    });

    print('learnedMagicards = ');
    learnedMagicards.forEach((element) {
      print(element.toString());
    });*/

    bool _cardIsLearned(int index) {
      if (index >= listOfCards.length - learnedMagicards.length) {
        return true;
      } else {
        return false;
      }
    }

    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: hexToColor('#B2B2B2'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              expandedHeight: kExpandedHeight + kToolbarHeight,
              title: _showTitle
                  ? Text(
                      widget.subtopic.title,
                      style: myToolbarTextStyle,
                    )
                  : null,
              flexibleSpace: _showTitle
                  ? null
                  : FlexibleSpaceBar(
                      background: SubtopicDetails(
                          subtopic: widget.subtopic,
                          numberOfCards: listOfCards.length),
                    ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CardContent(
                    card: listOfCardsSorted[index],
                    learned: _cardIsLearned(index),
                    listLearnedCardsIDs: listLearnedCardsIDs,
                    subtopicId: widget.subtopic.id,
                  ),
                  childCount: snapshot.length,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: RadialMenu(
              listOfCards: notLearnedMagicards,
              listLearnedCardsIDs: listLearnedCardsIDs,
              subtopicId: widget.subtopic.id,
            ),
          ),
        ),
      ],
    );
  }
}

class SubtopicDetails extends StatelessWidget {
  final Subtopic subtopic;
  final int numberOfCards;

  const SubtopicDetails({Key key, this.subtopic, this.numberOfCards})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 40,
              right: 40,
              top: 56 + kToolbarHeight,
            ),
            child: Container(
              child: Text(
                subtopic.title,
                style: myH1,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 40,
            ),
            child: Text(subtopic.titleRus, style: mySubtitle14Style),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 28,
            ),
            child: Container(
              width: 76,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Center(
                child: Text(_textNumberOfCards(numberOfCards),
                    style: myLabelTextStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _textNumberOfCards(int number) {
  if (number == 1) {
    return '1 слово';
  }
  if (number >= 2 && number <= 4) {
    return number.toString() + ' слова';
  } else {
    return number.toString() + ' слов';
  }
}

class CardContent extends StatelessWidget {
  final Magicard card;
  final bool learned;
  final List<String> listLearnedCardsIDs;
  final String subtopicId;

  const CardContent({
    Key key,
    this.card,
    this.learned, this.listLearnedCardsIDs, this.subtopicId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(_createRoute(card, listLearnedCardsIDs, subtopicId));
      },
      child: Ink(
        color: Colors.white,
        child: Padding(
          key: ValueKey(card.title),
          padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 0.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              left: 0.0,
              right: 0.0,
            ),
            leading: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  card.photo,
                  height: 70,
                  width: 70,
                  fit: card.whiteBg == '1' ? BoxFit.contain : BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              card.title,
              style: mySubtitle16Style,
            ),
            subtitle: Text(
              card.titleRus,
              style: mySubtitle14Style,
            ),
            trailing: SizedBox(
              width: 88,
              height: 25,
              child: learned
                  ? Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.green[600],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Изучено',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Magicard card, List<String> listLearnedCardsIDs, String subtopicId) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CardDetailsScreen(
      card: card,
      listLearnedCardsIDs: listLearnedCardsIDs,
      subtopicId: subtopicId,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
