import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'training_flashcards.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key key, this.topic, this.mapSubtopicsProgress})
      : super(key: key);

  final Topic topic;
  final Map<String, String>
      mapSubtopicsProgress; // For updating when more cards are learned.

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<String> listLearnedCardsIDs;
  List<Magicard> listOfAllCards = [];
  List<Magicard> notLearnedCardsLevel1 = [];
  List<Magicard> notLearnedCardsLevel2 = [];
  List<Magicard> learnedCardsLevel1 = [];
  List<Magicard> learnedCardsLevel2 = [];

/*@override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(widget.topic.title),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 1,
        isHomePage: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cards')
          .where('subtopic', isEqualTo: widget.topic.id)
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
              child: Center(
                child: Text("В этой категории нет слов"),
              ),
            );
          fillListOfAllCards(documents);

          if (user != null) {
            return Consumer<TrainingFlashcardsState>(
              builder: (context, state, child) {
                return FutureBuilder<List<String>>(
                  future: DB.getEarlyLearnedCardsIDs(user.uid, widget.topic.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      /*return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 24.0),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                        );*/
                      return Container();
                    } else {
                      listLearnedCardsIDs = snapshot.data;
                      fillLearnedAndNotLearnedCards();

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
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: convertHeightFrom360(
                                                    context, 360, 8)),
                                            CardsList(
                                                cards: notLearnedCardsLevel1,
                                                listLearnedCardsIDs:
                                                    listLearnedCardsIDs,
                                                topicId: widget.topic.id,
                                                mapSubtopicsProgress:
                                                    widget.mapSubtopicsProgress,
                                                numberOfCardsInSubtopic:
                                                    listOfAllCards.length),
                                            CardsList(
                                                cards: notLearnedCardsLevel2,
                                                listLearnedCardsIDs:
                                                    listLearnedCardsIDs,
                                                topicId: widget.topic.id,
                                                mapSubtopicsProgress:
                                                    widget.mapSubtopicsProgress,
                                                numberOfCardsInSubtopic:
                                                    listOfAllCards.length),
                                            SizedBox(
                                                height: convertHeightFrom360(
                                                    context, 360, 66)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  height:
                                      convertHeightFrom360(context, 360, 50),
                                  bottom:
                                      convertHeightFrom360(context, 360, 69),
                                  left: convertWidthFrom360(context, 16),
                                  right: convertWidthFrom360(context, 16),
                                  child: _buildTrainingButton(),
                                ),
                                Positioned(
                                  height:
                                      convertHeightFrom360(context, 360, 69),
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
                            child: Column(
                              children: [
                                SizedBox(
                                    height:
                                        convertHeightFrom360(context, 360, 8)),
                                CardsList(
                                    cards: learnedCardsLevel1,
                                    listLearnedCardsIDs: listLearnedCardsIDs,
                                    topicId: widget.topic.id,
                                    mapSubtopicsProgress:
                                        widget.mapSubtopicsProgress,
                                    numberOfCardsInSubtopic:
                                        listOfAllCards.length,
                                    learned: true), // Can remove?..
                                CardsList(
                                    cards: learnedCardsLevel2,
                                    listLearnedCardsIDs: listLearnedCardsIDs,
                                    topicId: widget.topic.id,
                                    mapSubtopicsProgress:
                                        widget.mapSubtopicsProgress,
                                    numberOfCardsInSubtopic:
                                        listOfAllCards.length,
                                    learned: true),
                                SizedBox(
                                    height:
                                        convertHeightFrom360(context, 360, 66)),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Container(
              child: Text("Карточки для незалогиненного"),
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

  Widget _buildTrainingButton() {
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
          onPressed: widget.mapSubtopicsProgress[widget.topic.id] == "1.0"
              ? null
              : () {
                  var state = Provider.of<TrainingFlashcardsState>(context,
                      listen: false);
                  state.progress = (1 /
                      (notLearnedCardsLevel1 + notLearnedCardsLevel2).length);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => TrainingFlashcards(
                          trainingVariant: 0,
                          listOfCards:
                              notLearnedCardsLevel1 + notLearnedCardsLevel2,
                          listLearnedCardsIDs: listLearnedCardsIDs,
                          topicId: widget.topic.id,
                          mapSubtopicsProgress: widget.mapSubtopicsProgress,
                          numberOfCardsInSubtopic: listOfAllCards.length),
                    ),
                  );
                },
        ),
      ],
    );
  }
}
