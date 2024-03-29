import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'training_flashcards.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  // All cards in topic
  List<Magicard> listOfAllCards = [];

  // For unauthorized user
  List<Magicard> allCardsLevel1 = [];
  List<Magicard> allCardsLevel2 = [];

  // For authorized user
  List<String> listLearnedCardsIDs = [];
  List<Magicard> notLearnedCardsLevel1 = [];
  List<Magicard> notLearnedCardsLevel2 = [];
  List<Magicard> learnedCardsLevel1 = [];
  List<Magicard> learnedCardsLevel2 = [];
  List<Magicard> cardsForTraining = [];

  var learningState;

  @override
  Widget build(BuildContext context) {
    //await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    learningState = Provider.of<LearningState>(context, listen: false);

    return FutureBuilder<bool>(
        future: FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return NetworkSensitive(
              child: Scaffold(
                extendBody: true, // For making BottomNavigationBar transparent.
                backgroundColor: MyColors.mainBgColor,
                body: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: convertHeightFrom360(context, 360, 10)),
                      Container(
                        height: convertHeightFrom360(context, 360, 32),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: convertWidthFrom360(context, 16)),
                          child: Material(
                            color: hexToColor("#E4E4E5"),
                            borderRadius: BorderRadius.circular(10),
                            child: TabBar(
                              indicatorPadding: const EdgeInsets.all(2.0),
                              indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tabs: [
                                Tab(text: "На изучении"),
                                Tab(text: "Изучено"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: convertHeightFrom360(context, 360, 8)),
                      Expanded(
                        child: _buildBody(context),
                      ),
                    ],
                  ),
                ),
                appBar: AppBar(
                  elevation: 0, // Removes status bar's shadow.
                  backgroundColor: MyColors.mainBgColor,
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: MyColors.mainBgColor,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  title: Text(
                    learningState.topic.title,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                bottomNavigationBar: AppBottomNav(
                  selectedIndex: 1,
                  isHomePage: false,
                ),
              ),
            );
          }
        });
  }

  Widget _buildBody(BuildContext context) {
    User user = Provider.of<User>(context);
    var learningState = Provider.of<LearningState>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cards')
          .where('subtopic',
              isEqualTo: learningState.topic.categoryNumber +
                  " " +
                  learningState.topic.id)
          .where('version_br', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var documents = snapshot.data.docs;
          if (documents.length == 0)
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "В этой категории нет слов",
                textAlign: TextAlign.center,
              ),
            );
          fillListOfAllCards(documents);

          learningState.numberOfCardsInTopic = listOfAllCards.length;

          if (user != null) {
            return StreamBuilder<List<String>>(
                stream: DB.getEarlyLearnedCardsIDsStream(
                    user.uid, learningState.topic.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgress();
                  } else {
                    listLearnedCardsIDs.clear();
                    listLearnedCardsIDs = snapshot.data;
                    fillLearnedAndNotLearnedCards();

                    learningState.listLearnedCardsIDs.clear();
                    learningState.listLearnedCardsIDs = listLearnedCardsIDs;

                    cardsForTraining =
                        notLearnedCardsLevel1 + notLearnedCardsLevel2;

                    return TabBarView(
                      children: [
                        // TAB 1: Not learned cards
                        Container(
                          height: double.infinity,
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: cardsForTraining.length == 0
                                          ? Column(
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            24.0),
                                                    child: Text(
                                                      "Вы изучили все слова этой темы",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                notLearnedCardsLevel1.length > 0
                                                    ? _buildLabelLevel(
                                                        "Уровень A1 - A2")
                                                    : Container(),
                                                CardsList(
                                                    cards:
                                                        notLearnedCardsLevel1),
                                                notLearnedCardsLevel1.length > 0
                                                    ? SizedBox(
                                                        height:
                                                            convertHeightFrom360(
                                                                context,
                                                                360,
                                                                16),
                                                      )
                                                    : Container(),
                                                notLearnedCardsLevel2.length > 0
                                                    ? _buildLabelLevel(
                                                        "Уровень Upper A2 - B1")
                                                    : Container(),
                                                CardsList(
                                                    cards:
                                                        notLearnedCardsLevel2),
                                                SizedBox(
                                                  height: convertHeightFrom360(
                                                      context, 360, 134),
                                                ),
                                              ],
                                            ),
                                    ),
                                    Text("Всего слов: " +
                                        listOfAllCards.length.toString()),
                                    SizedBox(
                                      height: convertHeightFrom360(
                                          context, 360, 130),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                height: convertHeightFrom360(context, 360, 50),
                                bottom: convertHeightFrom360(context, 360, 69),
                                left: convertWidthFrom360(context, 16),
                                right: convertWidthFrom360(context, 16),
                                child: _buildTrainingButton(),
                              ),
                              Positioned(
                                height: convertHeightFrom360(context, 360, 69),
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: MyColors.mainBgColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TAB 2: Learned cards
                        SingleChildScrollView(
                          child: (learnedCardsLevel1 + learnedCardsLevel2)
                                      .length !=
                                  0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    learnedCardsLevel1.length > 0
                                        ? _buildLabelLevel("Уровень A1 - A2")
                                        : Container(),
                                    CardsList(cards: learnedCardsLevel1),
                                    learnedCardsLevel1.length > 0
                                        ? SizedBox(
                                            height: convertHeightFrom360(
                                                context, 360, 16),
                                          )
                                        : Container(),
                                    learnedCardsLevel2.length > 0
                                        ? _buildLabelLevel(
                                            "Уровень Upper A2 - B1")
                                        : Container(),
                                    CardsList(cards: learnedCardsLevel2),
                                    SizedBox(
                                        height: convertHeightFrom360(
                                            context, 360, 66)),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        "Вы еще не отметили ни одно слово из этой темы изученным",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      ],
                    );
                  }
                });
          } else {
            cardsForTraining = [];
            cardsForTraining = listOfAllCards;

            fillAllCardsLevel1AndLevel2();

            return TabBarView(
              children: [
                // TAB 1: All cards
                Container(
                  height: double.infinity,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  allCardsLevel1.length > 0
                                      ? _buildLabelLevel("Уровень A1 - A2")
                                      : Container(),
                                  CardsList(cards: allCardsLevel1),
                                  allCardsLevel1.length > 0
                                      ? SizedBox(
                                          height: convertHeightFrom360(
                                              context, 360, 16),
                                        )
                                      : Container(),
                                  allCardsLevel2.length > 0
                                      ? _buildLabelLevel(
                                          "Уровень Upper A2 - B1")
                                      : Container(),
                                  CardsList(cards: allCardsLevel2),
                                  SizedBox(
                                    height:
                                        convertHeightFrom360(context, 360, 134),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        height: convertHeightFrom360(context, 360, 69),
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: MyColors.mainBgColor,
                        ),
                      ),
                      Positioned(
                        height: convertHeightFrom360(context, 360, 50),
                        bottom: convertHeightFrom360(context, 360, 69),
                        left: convertWidthFrom360(context, 16),
                        right: convertWidthFrom360(context, 16),
                        child: _buildTrainingButton(),
                      ),
                    ],
                  ),
                ),
                // TAB 2: Offer to sign in
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Войдите в приложение, чтобы отмечать слова изученными",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  fillListOfAllCards(List<DocumentSnapshot> documents) {
    listOfAllCards.clear();

    for (var i = 0; i < documents.length; i++) {
      DocumentSnapshot cardSnapshot = documents[i];
      Magicard card = Magicard.fromSnapshot(cardSnapshot.id, cardSnapshot);
      listOfAllCards.add(card);
    }
  }

  // For unauthorized user
  fillAllCardsLevel1AndLevel2() {
    allCardsLevel1.clear();
    allCardsLevel2.clear();

    listOfAllCards.forEach((card) {
      card.level == "A1 - A2"
          ? allCardsLevel1.add(card)
          : allCardsLevel2.add(card);
    });
  }

  // For authorized user
  fillLearnedAndNotLearnedCards() {
    learnedCardsLevel1.clear();
    learnedCardsLevel2.clear();
    notLearnedCardsLevel1.clear();
    notLearnedCardsLevel2.clear();

    listOfAllCards.forEach((card) {
      if (listLearnedCardsIDs.contains(card.id)) {
        card.level == "A1 - A2"
            ? learnedCardsLevel1.add(card)
            : learnedCardsLevel2.add(card);
      } else {
        card.level == "A1 - A2"
            ? notLearnedCardsLevel1.add(card)
            : notLearnedCardsLevel2.add(card);
      }
    });
  }

  Widget _buildLabelLevel(String label) {
    return Padding(
      padding: EdgeInsets.only(
        top: convertHeightFrom360(context, 360, 16),
        bottom: convertHeightFrom360(context, 360, 22),
        left: convertWidthFrom360(context, 16),
      ),
      child: Text(
        label,
        style: mySubtitleStyle,
      ),
    );
  }

  Widget _buildTrainingButton() {
    var learningState = Provider.of<LearningState>(context, listen: false);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 40,
          color: MyColors.mainBgColor,
        ),
        ElevatedButton(
          style: myPrimaryButtonStyle,
          child: Center(
              child: Text("Тренироваться", style: myPrimaryButtonTextStyle)),
          onPressed: cardsForTraining.length == 0
              ? null
              : () {
                  var trainingState =
                      Provider.of<TrainingState>(context, listen: false);
                  trainingState.trainingProgress =
                      (1 / cardsForTraining.length);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TrainingFlashcards(cardsForTraining),
                    ),
                  );
                },
        )
      ],
    );
  }
}
