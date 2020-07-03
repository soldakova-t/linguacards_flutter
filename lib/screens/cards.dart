import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magicards/screens/card_details.dart';
import 'package:magicards/screens/training_flashcards.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class CardsScreen extends StatefulWidget {
  final Subtopic subtopic;
  CardsScreen({Key key, this.subtopic}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  static const kExpandedHeight = 155.0;
  ScrollController _scrollController;
  List<Magicard> listOfCards = List<Magicard>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: Container(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ChooseVariantOverlay(
                  listOfCards: listOfCards,
                ),
              );
            },
            backgroundColor: MyColors.mainBrightColor,
            child: Icon(Icons.donut_small),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('cards')
          .where('subtopic', isEqualTo: widget.subtopic.title)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    listOfCards =
        snapshot.map((document) => Magicard.fromSnapshot(document)).toList();

    return CustomScrollView(
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
                  background: SubtopicDetails(subtopic: widget.subtopic),
                ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 15,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CardContent(
                card: Magicard.fromSnapshot(snapshot[index]),
                learned: false,
              ),
              childCount: snapshot.length,
            ),
          ),
        ),
      ],
    );
  }
}

class SubtopicDetails extends StatelessWidget {
  final Subtopic subtopic;

  const SubtopicDetails({Key key, this.subtopic}) : super(key: key);

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
                child: Text('240 слов', style: myLabelTextStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Magicard card;
  final bool learned;

  const CardContent({
    Key key,
    this.card,
    this.learned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(_createRoute(card));
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
              child: Row(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseVariantOverlay extends StatelessWidget {
  ChooseVariantOverlay({
    Key key,
    this.listOfCards,
  }) : super(key: key);

  final List<Magicard> listOfCards;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 30.0, bottom: 85.0),
        child: Container(
            height: 123.0,
            width: 320.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: 320,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 22),
                        Icon(Icons.favorite),
                        SizedBox(width: 16),
                        Text(
                          'Скрыть изображения',
                          style: myVariantsTextStyle,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => TrainingFlashcards(
                          listOfCards: listOfCards,
                          trainingVariant: 0,
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: 320,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 22),
                        Icon(Icons.favorite),
                        SizedBox(width: 16),
                        Text(
                          'Скрыть английские слова',
                          style: myVariantsTextStyle,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => TrainingFlashcards(
                          listOfCards: listOfCards,
                          trainingVariant: 1,
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}

Route _createRoute(Magicard card) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CardDetailsScreen(card: card),
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