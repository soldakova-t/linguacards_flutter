import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:magicards/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ButtonLearned extends StatefulWidget {
  const ButtonLearned({
    Key key,
    this.heroTag,
    this.context,
    this.listLearnedCardsIDs,
    this.topicId,
    this.cardId,
    this.learned,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
  }) : super(key: key);

  final String heroTag;
  final BuildContext context;
  final List<String> listLearnedCardsIDs;
  final Map<String, String> mapSubtopicsProgress;
  final String topicId;
  final String cardId;
  final bool learned;
  final int numberOfCardsInSubtopic;

  @override
  _ButtonLearnedState createState() => _ButtonLearnedState();
}

class _ButtonLearnedState extends State<ButtonLearned> {
  bool _learned = false;

  @override
  void initState() {
    super.initState();
    _learned = widget.learned;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(widget.context, listen: false);

    return Container(
      height: convertHeightFrom360(context, 360, 46),
      child: _learned == false
          ? ElevatedButton(
              style: mySecondaryButtonStyle,
              child: Center(
                  child: Text("Отметить изученным",
                      style: mySecondaryButtonTextStyle)),
              onPressed: user != null
                  ? () {
                      widget.listLearnedCardsIDs.add(widget.cardId);

                      DB.updateArrayOfLearnedCards(
                          userId: user.uid,
                          subtopicId: widget.topicId,
                          learnedCardsIDs: widget.listLearnedCardsIDs);

                      double _newProgress = widget.listLearnedCardsIDs.length /
                          widget.numberOfCardsInSubtopic;
                      widget.mapSubtopicsProgress.update(
                          widget.topicId, (value) => (_newProgress).toString(),
                          ifAbsent: () => (_newProgress).toString());

                      DB.updateSubtopicsProgress(
                        user.uid,
                        widget.mapSubtopicsProgress,
                      );

                      setState(() {
                        _learned = true;
                      });

                      var state = Provider.of<TrainingFlashcardsState>(context,
                          listen: false);
                      state.needRefreshCardsList = true;
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
                          _learned = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          widget.listLearnedCardsIDs.remove(widget.cardId);

                          DB.updateArrayOfLearnedCards(
                              userId: user.uid,
                              subtopicId: widget.topicId,
                              learnedCardsIDs: widget.listLearnedCardsIDs);

                          double _newProgress =
                              widget.listLearnedCardsIDs.length /
                                  widget.numberOfCardsInSubtopic;
                          widget.mapSubtopicsProgress.update(widget.topicId,
                              (value) => (_newProgress).toString(),
                              ifAbsent: () => (_newProgress).toString());

                          DB.updateSubtopicsProgress(
                            user.uid,
                            widget.mapSubtopicsProgress,
                          );

                          setState(() {
                            _learned = false;
                          });

                          var state = Provider.of<TrainingFlashcardsState>(
                              context,
                              listen: false);
                          state.needRefreshCardsList = true;
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
