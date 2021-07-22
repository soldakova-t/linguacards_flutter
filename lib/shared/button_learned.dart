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
  var learningState;
  Magicard card;
  User user;
  bool learned = false;

  @override
  void initState() {
    super.initState();

    learningState = Provider.of<LearningState>(context, listen: false);
    card = learningState.card;

    user = Provider.of<User>(context, listen: false);
    if (user != null) {
      if (learningState.listLearnedCardsIDs != null) {
        if (learningState.listLearnedCardsIDs.contains(card.id)) {
          learned = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: convertHeightFrom360(context, 360, 46),
      child: learned == false
          ? ElevatedButton(
              style: mySecondaryButtonStyle,
              child: Center(
                  child: Text("Отметить изученным",
                      style: mySecondaryButtonTextStyle)),
              onPressed: user != null
                  ? () {
                      learningState.listLearnedCardsIDs.add(card.id);

                      DB.updateArrayOfLearnedCards(
                          userId: user.uid,
                          subtopicId: learningState.topic.id,
                          learnedCardsIDs: learningState.listLearnedCardsIDs);

                      double _newProgress =
                          learningState.listLearnedCardsIDs.length /
                              learningState.numberOfCardsInSubtopic;
                      learningState.mapTopicsProgress.update(
                          learningState.topic.id,
                          (value) => (_newProgress).toString(),
                          ifAbsent: () => (_newProgress).toString());

                      DB.updateSubtopicsProgress(
                        user.uid,
                        learningState.mapTopicsProgress,
                      );

                      setState(() {
                        learned = true;
                      });

                    }
                  : () {
                      Navigator.pushNamed(context, '/settings');
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
                          learningState.listLearnedCardsIDs
                              .remove(learningState.card.id);

                          DB.updateArrayOfLearnedCards(
                              userId: user.uid,
                              subtopicId: learningState.topic.id,
                              learnedCardsIDs:
                                  learningState.listLearnedCardsIDs);

                          double _newProgress =
                              learningState.listLearnedCardsIDs.length /
                                  learningState.numberOfCardsInSubtopic;
                          learningState.mapTopicsProgress.update(
                              learningState.topic.id,
                              (value) => (_newProgress).toString(),
                              ifAbsent: () => (_newProgress).toString());

                          DB.updateSubtopicsProgress(
                            user.uid,
                            learningState.mapTopicsProgress,
                          );

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
            ),
    );
  }
}
