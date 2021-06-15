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
  List<Magicard> notLearnedCards = [];
  List<Magicard> learnedCards = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true, // For making BottomNavigationBar transparent.
        backgroundColor: MyColors.mainBgColor,
        body: _buildBody(context),
        appBar: AppBar(
          elevation: 0, // Removes status bar's shadow.
          backgroundColor: MyColors.mainBgColor,
          title: Text(widget.topic.title),
          bottom: TabBar(
            indicatorPadding: const EdgeInsets.all(4.0),
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: myNotLearnedTabLabelStyle,
            unselectedLabelColor: MyColors.subtitleColor,
            unselectedLabelStyle: myLearnedTabLabelStyle,
            tabs: [
              Tab(text: "На изучении"),
              Tab(text: "Изученные"),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          selectedIndex: 1,
          isHomePage: false,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    String userEnglishVersion = "br";

    return TabBarView(
      children: [
        Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('cards')
                          .where('subtopic', isEqualTo: widget.topic.id)
                          .where('eng_version.$userEnglishVersion',
                              isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return LinearProgressIndicator();
                        } else {
                          var documents = snapshot.data.documents;
                          fillListOfAllCards(documents);
                          if (user != null) {
                            return FutureBuilder<List<String>>(
                              future: DB.getEarlyLearnedCardsIDs(
                                  user.uid, widget.topic.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return LinearProgressIndicator();
                                } else {
                                  listLearnedCardsIDs = snapshot.data;
                                  fillLearnedAndNotLearnedCards();
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: convertHeightFrom360(
                                                context, 360, 16)),
                                        CardsList(cards: notLearnedCards),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: CardsList(cards: listOfAllCards),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: convertHeightFrom360(context, 360, 80)),
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
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CardsList(cards: learnedCards, learned: true),
          ),
        ),
      ],
    );
  }

  fillListOfAllCards(List<DocumentSnapshot> documents) {
    listOfAllCards.clear();

    for (var i = 0; i < documents.length; i++) {
      DocumentSnapshot cardSnapshot = documents[i];
      Magicard card =
          Magicard.fromSnapshot(cardSnapshot.documentID, cardSnapshot);
      listOfAllCards.add(card);
    }
  }

  fillLearnedAndNotLearnedCards() {
    learnedCards.clear();
    notLearnedCards.clear();

    listOfAllCards.forEach((card) {
      listLearnedCardsIDs.contains(card.id)
          ? learnedCards.add(card)
          : notLearnedCards.add(card);
    });
  }

  Widget _buildTrainingButton() {
    return ElevatedButton(
        style: myPrimaryButtonStyle,
        child: Center(
            child: Text("Тренироваться", style: myPrimaryButtonTextStyle)),
        onPressed: widget.mapSubtopicsProgress[widget.topic.id] == "1.0"
            ? null
            : () {
                var state = Provider.of<TrainingFlashcardsState>(context,
                    listen: false);
                state.progress = (1 / notLearnedCards.length);

                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => TrainingFlashcards(
                            trainingVariant: 0,
                            listOfCards: notLearnedCards,
                            listLearnedCardsIDs: listLearnedCardsIDs,
                            topicId: widget.topic.id,
                            mapSubtopicsProgress: widget.mapSubtopicsProgress,
                            numberOfCardsInSubtopic: listOfAllCards.length),
                      ),
                    )
                    .then((value) => setState(() {}));
              });
  }
}
