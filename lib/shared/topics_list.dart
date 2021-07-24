import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import '../services/globals.dart';
import '../services/db.dart';

class TopicsList extends StatefulWidget {
  const TopicsList({
    Key key,
    @required this.topics,
    this.orientation,
    this.withButtonContinue,
  }) : super(key: key);

  final List<Topic> topics;
  final String orientation;
  final bool withButtonContinue;

  @override
  _TopicsListState createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList> {
  @override
  Widget build(BuildContext context) {
    var learningState = Provider.of<LearningState>(context, listen: false);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: convertWidthFrom360(context, 16)),
      child: ColumnBuilder(
          itemCount: widget.topics.length,
          itemBuilder: (BuildContext context, int index) {
            int numberOfLearnedCards = 0;

            User user = Provider.of<User>(context);
            if (user != null) {
              
              return StreamBuilder(
                stream: DB.getUserInfoStream(user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> userInfo = snapshot.data;

                    // Updating learningState.mapTopicsProgress if userInfo != null
                    learningState.topicsNumbersLearnedCards = {};
                    
                    if (userInfo != null) {
                      if (userInfo["topics_numbers_learned_cards"] != null) {
                        learningState.topicsNumbersLearnedCards =
                            Map<String, int>.from(Map<String, dynamic>.from(
                                userInfo["topics_numbers_learned_cards"]));
                      }
                    }

                    // Updating progress for current topic if learningState.mapTopicsProgress != null
                    if (learningState.topicsNumbersLearnedCards != null) {
                      if (learningState
                              .topicsNumbersLearnedCards[widget.topics[index].id] !=
                          null) {
                        numberOfLearnedCards = learningState
                            .topicsNumbersLearnedCards[widget.topics[index].id];
                      }
                    }
                    
                    return _TopicsListItem(
                        widget.topics[index], numberOfLearnedCards);
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              learningState.topicsNumbersLearnedCards = null;
              return _TopicsListItem(widget.topics[index], 0);
            }
          }),
    );
  }
}

class _TopicsListItem extends StatelessWidget {
  const _TopicsListItem(this.topic, this.numberOfLearnedCards, {Key key})
      : super(key: key);

  final Topic topic;
  final int numberOfLearnedCards;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    double progress = numberOfLearnedCards / topic.numberOfCards;

    return GestureDetector(
      onTap: () {
        var learningState = Provider.of<LearningState>(context, listen: false);
        learningState.topic = topic;
        return Navigator.of(context).push(createRouteScreen("/cards"));
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: convertHeightFrom360(context, 360, 10)),
        child: SizedBox(
          width: double.infinity,
          height: convertHeightFrom360(context, 360, 115),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(convertWidthFrom360(context, 16)),
                    color: Colors.white,
                  ),
                ),
              ),
              // Label popular topic
              /*Positioned(
                top: 0,
                right: 16,
                child: Container(
                  height: convertHeightFrom360(context, 360, 17),
                  width: convertWidthFrom360(context, 71),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(convertWidthFrom360(context, 6)),
                    color: MyColors.popularBgColor,
                  ),
                  child: Center(
                    child: Text("Популярная", style: myPopularLabelStyle),
                  ),
                ),
              ),*/
              Positioned(
                left: convertWidthFrom360(context, 16),
                top: convertHeightFrom360(context, 360, 18),
                right: convertWidthFrom360(context, 76),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(topic.title, style: myTitleStyle),
                    SizedBox(height: convertHeightFrom360(context, 360, 5)),
                    Text(topic.titleRus, style: mySubtitleStyle),
                    SizedBox(height: convertHeightFrom360(context, 360, 5)),
                  ],
                ),
              ),
              Positioned(
                left: convertWidthFrom360(context, 16),
                bottom: convertHeightFrom360(context, 360, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "изучено " +
                            numberOfLearnedCards.toString() +
                            " слов из " +
                            topic.numberOfCards.toString(),
                        style: myPercentStyle),
                    SizedBox(height: convertWidthFrom360(context, 5)),
                    Container(
                      width: convertWidthFrom360(context, 150),
                      child: AnimatedProgress(
                        height: convertHeightFrom360(context, 360, 3),
                        value: progress,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: convertWidthFrom360(context, -4),
                top: convertHeightFrom360(context, 360, 38),
                child: Container(
                  width: convertWidthFrom360(context, 66),
                  height: convertHeightFrom360(context, 360, 66),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage("http://magicards.ru/topics_photos/" +
                          topic.categoryNumber +
                          "/" +
                          topic.number +
                          ".jpg"),
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
