import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magicards/screens/card_details.dart';
import 'package:magicards/screens/cards_radial_menu.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

/*class CardsArchiveScreen extends StatefulWidget {
  final Topic topic;
  final Map<String, String> userAllTopicsProgress;
  final Map<String, dynamic> userInfo;

  CardsArchiveScreen(
    this.topic,
    this.userAllTopicsProgress, {
    Key key,
    this.userInfo,
  }) : super(key: key);

  @override
  _CardsArchiveScreenState createState() => _CardsArchiveScreenState();
}

class _CardsArchiveScreenState extends State<CardsArchiveScreen>
    with SingleTickerProviderStateMixin {
  static const kExpandedHeight = 155.0;

  ScrollController _scrollController;
  AnimationController _animatedFABController;

  List<Magicard> listOfCards;
  List<String> listLearnedCardsIDs;

  bool hideCards;
  String userEnglishVersion = "br";

  @override
  void initState() {
    super.initState();

    hideCards = widget.userInfo != null ? !widget.userInfo["premium"] : true;

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
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      userEnglishVersion = widget.userInfo != null
          ? (widget.userInfo["eng_version"] ?? "br")
          : "br";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          hideCards
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 180.0),
                  child: _buildBody(context),
                )
              : _buildBody(context),
          hideCards ? buildPremiumContainer() : Container(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
    
  }

  Align buildPremiumContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 180.0,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            MainButton(title: 'Купить Премиум за 1490 ₽', action: () {}),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 210,
                height: 74,
                child: Text(
                  'Вы получите бессрочный доступ к каталогу из 2500+ карточек',
                  style: mySubtitle14Style,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('cards')
          .where('subtopic', isEqualTo: widget.topic.id)
          .where('eng_version.$userEnglishVersion', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          var documents = snapshot.data.documents;
          if (user != null) {
            return FutureBuilder<List<String>>(
              future: DB.getEarlyLearnedCardsIDs(
                  userId: user.uid, subtopicId: widget.topic.id),
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
    );
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
                      widget.topic.title,
                      style: myToolbarTextStyle,
                    )
                  : null,
              flexibleSpace: _showTitle
                  ? null
                  : FlexibleSpaceBar(
                      background: SubtopicDetails(
                        subtopic: widget.topic,
                        numberOfCards: listOfCards.length,
                        showPremiumLabel: hideCards,
                      ),
                    ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 30,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CardContent(
                    card: listOfCardsSorted[index],
                    learned: _cardIsLearned(index),
                    listLearnedCardsIDs: listLearnedCardsIDs,
                    subtopicId: widget.topic.id,
                    mapSubtopicsProgress: widget.userAllTopicsProgress,
                    numberOfCardsInSubtopic: listOfCards.length,
                    hideCards: hideCards,
                    userInfo: widget.userInfo,
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
            child: (notLearnedMagicards.length > 0 && !hideCards)
                ? RadialMenu(
                    listOfCards: notLearnedMagicards,
                    listLearnedCardsIDs: listLearnedCardsIDs,
                    subtopicId: widget.topic.id,
                    mapSubtopicsProgress: widget.userAllTopicsProgress,
                    userInfo: widget.userInfo,
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}

class SubtopicDetails extends StatelessWidget {
  final Topic subtopic;
  final int numberOfCards;
  final bool showPremiumLabel;

  const SubtopicDetails(
      {Key key, this.subtopic, this.numberOfCards, this.showPremiumLabel})
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
            child: Row(
              children: <Widget>[
                Container(
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
                showPremiumLabel
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 19),
                          SvgPicture.asset("assets/icons/crown.svg"),
                          SizedBox(width: 11),
                          Text(
                            "Премиум",
                            style: TextStyle(
                              fontSize: 13,
                              color: MyColors.mainBrightColor,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
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
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;
  final bool hideCards;
  final Map<String, dynamic> userInfo;

  const CardContent({
    Key key,
    this.card,
    this.learned,
    this.listLearnedCardsIDs,
    this.subtopicId,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
    this.hideCards,
    this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !hideCards
        ? InkWell(
            onTap: () {
              Navigator.of(context).push(_createRouteToCardDetails(
                  card,
                  listLearnedCardsIDs,
                  subtopicId,
                  mapSubtopicsProgress,
                  numberOfCardsInSubtopic,
                  userInfo));
            },
            child: buildCardInnerContent(),
          )
        : buildCardInnerContent();
  }

  Widget buildCardInnerContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 0.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 20.0, bottom: 8.0),
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
          hideCards
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 74,
                      height: 10,
                      color: MyColors.hideAccessColor,
                    ),
                    SizedBox(height: 11),
                    Container(
                      width: 109,
                      height: 10,
                      color: MyColors.hideAccessColor,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      capitalize(card.title),
                      style: mySubtitle16Style,
                    ),
                    Text(
                      capitalize(card.titleRus),
                      style: mySubtitle14Style,
                    ),
                  ],
                ),
          hideCards
              ? Container()
              : Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
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
        ],
      ),
    );
  }
}

Route _createRouteToCardDetails(
    Magicard card,
    List<String> listLearnedCardsIDs,
    String subtopicId,
    Map<String, String> mapSubtopicsProgress,
    int numberOfCardsInSubtopic,
    Map<String, dynamic> userInfo) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CardDetailsScreen(
      card: card,
      listLearnedCardsIDs: listLearnedCardsIDs,
      subtopicId: subtopicId,
      mapSubtopicsProgress: mapSubtopicsProgress,
      numberOfCardsInSubtopic: numberOfCardsInSubtopic,
      userInfo: userInfo,
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
}*/
