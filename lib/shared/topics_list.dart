import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magicards/services/models.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import '../services/globals.dart';

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
  Map<String, dynamic> userInfo;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: convertWidthFrom360(context, 16)),
      child: ColumnBuilder(
          itemCount: widget.topics.length,
          itemBuilder: (BuildContext context, int index) {
            if (user != null) {
              return StreamBuilder(
                stream: DB.getUserInfoStream(user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    userInfo = snapshot.data;
                    return _buildTopicsListItem(context, index,
                        userInfo: userInfo);
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return _buildTopicsListItem(context, index);
            }
          }),
    );
  }

  Widget _buildTopicsListItem(BuildContext context, int index,
      {Map<String, dynamic> userInfo}) {
    double progress = 0.0;
    if (userInfo != null) {
      if (userInfo["subtopics_progress"] != null) {
        if (userInfo["subtopics_progress"][widget.topics[index].id] != null) {
          progress = double.parse(
              userInfo["subtopics_progress"][widget.topics[index].id]);
        }
      }
    }

    return GestureDetector(
      onTap: () {
        if (userInfo != null) {
          if (userInfo["subtopics_progress"] != null) {
            Map<String, dynamic> dynamicSubtopicsProgress =
                userInfo["subtopics_progress"];
            Map<String, String> stringSubtopicsProgress =
                dynamicSubtopicsProgress
                    .map((key, value) => MapEntry(key, value?.toString()));

            Navigator.of(context).push(createRouteScreen("/cards",
                topic: widget.topics[index],
                mapSubtopicsProgress: stringSubtopicsProgress));
          } else
            return Navigator.of(context)
                .push(createRouteScreen("/cards", topic: widget.topics[index]));
        } else
          return Navigator.of(context)
              .push(createRouteScreen("/cards", topic: widget.topics[index]));
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: convertHeightFrom360(context, 360, 10)),
        child: SizedBox(
          width: double.infinity,
          height: convertHeightFrom360(context, 360, 113),
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
              // Label "Популярная"
              /*widget.topics[index].popular
                  ? Positioned(
                      top: 0,
                      right: 10,
                      child: Container(
                        height: convertHeightFrom360(context, 360, 17),
                        width: convertWidthFrom360(context, 71),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              convertWidthFrom360(context, 6)),
                          color: MyColors.popularBgColor,
                        ),
                        child: Center(
                          child: Text("Популярная", style: myPopularLabelStyle),
                        ),
                      ),
                    )
                  : Container(),*/
              Positioned(
                left: convertWidthFrom360(context, 16),
                top: convertHeightFrom360(context, 360, 18),
                right: convertWidthFrom360(context, 76),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.topics[index].title, style: myTitleStyle),
                    SizedBox(height: convertHeightFrom360(context, 360, 5)),
                    Text(widget.topics[index].titleRus, style: mySubtitleStyle),
                    SizedBox(height: convertHeightFrom360(context, 360, 14)),
                  ],
                ),
              ),
              Positioned(
                left: convertWidthFrom360(context, 16),
                bottom: convertHeightFrom360(context, 360, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text((progress * 100).toInt().toString() + "% изучено",
                        style: myPercentStyle),
                    SizedBox(height: convertWidthFrom360(context, 5)),
                    Container(
                      width: convertWidthFrom360(context, 120),
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
                                    widget.topics[index].categoryNumber +
                                    "/" +
                                    widget.topics[index].number +
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
