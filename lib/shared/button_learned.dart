import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:magicards/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ButtonLearned extends StatefulWidget {
  @override
  _ButtonLearnedState createState() => _ButtonLearnedState();
}

class _ButtonLearnedState extends State<ButtonLearned> {
  User user;
  var learningState;
  Magicard card;
  bool learned = false;

  @override
  Widget build(BuildContext context) {
    learningState = Provider.of<LearningState>(context);
    card = learningState.card;

    user = Provider.of<User>(context);
    if (user != null) {
      if (learningState.listLearnedCardsIDs != null) {
        if (learningState.listLearnedCardsIDs.contains(card.id)) {
          learned = true;
        }
      }
    }

    return Container(
      height: convertHeightFrom360(context, 360, 46),
      child: user != null
          ? _buildButtonMarkingAsLearned()
          : _buildButtonLeadingToLogin(),
    );
  }

  Widget _buildButtonMarkingAsLearned() {
    return learned == false
        ? ElevatedButton(
            style: mySecondaryButtonStyle,
            child: Center(
                child: Text("Отметить изученным",
                    style: mySecondaryButtonTextStyle)),
            onPressed: () {
              List<String> newListLearnedCardsIDs =
                  learningState.listLearnedCardsIDs;

              newListLearnedCardsIDs.add(learningState.card.id);

              Map<String, int> newTopicsNumbersLearnedCards =
                  learningState.topicsNumbersLearnedCards;

              newTopicsNumbersLearnedCards[learningState.topic.id] =
                  learningState.listLearnedCardsIDs.length;

              DB.updateArrayOfLearnedCards(
                  userId: user.uid,
                  subtopicId: learningState.topic.id,
                  learnedCardsIDs: newListLearnedCardsIDs);

              DB.updateTopicsNumbersLearnedCards(
                user.uid,
                newTopicsNumbersLearnedCards,
              );

              learningState.listLearnedCardsIDs.clear();
              learningState.listLearnedCardsIDs = newListLearnedCardsIDs;

              learningState.topicsNumbersLearnedCards =
                  newTopicsNumbersLearnedCards;

              setState(() {
                learned = true;
              });
            },
          )
        : Container(
            height: 48,
            alignment: Alignment.center,
            child: SizedBox(
              width: 180,
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Изучено",
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        learned = false;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        List<String> newListLearnedCardsIDs =
                            learningState.listLearnedCardsIDs;

                        newListLearnedCardsIDs.remove(learningState.card.id);

                        Map<String, int> newtTopicsNumbersLearnedCards =
                            learningState.topicsNumbersLearnedCards;

                        newtTopicsNumbersLearnedCards[learningState.topic.id] =
                            learningState.listLearnedCardsIDs.length;

                        DB.updateArrayOfLearnedCards(
                            userId: user.uid,
                            subtopicId: learningState.topic.id,
                            learnedCardsIDs: newListLearnedCardsIDs);

                        DB.updateTopicsNumbersLearnedCards(
                          user.uid,
                          newtTopicsNumbersLearnedCards,
                        );

                        learningState.listLearnedCardsIDs =
                            newListLearnedCardsIDs;
                        learningState.topicsNumbersLearnedCards =
                            newtTopicsNumbersLearnedCards;

                        setState(() {
                          learned = false;
                        });
                      },
                      child: Text(
                        "Вернуть",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF878787),
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildButtonLeadingToLogin() {
    return ElevatedButton(
      style: mySecondaryButtonStyle,
      child: Center(
          child: Text("Отметить изученным", style: mySecondaryButtonTextStyle)),
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/login',
          arguments: {"prevScreen": "cardDetails"},
        );
      },
    );
  }
}
