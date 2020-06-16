import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubtopicsScreen extends StatelessWidget {
  final Topic topic;

  const SubtopicsScreen({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TopicDetails(topic: topic),
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SubtopicsList(topic: topic),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
  }
}

class TopicDetails extends StatelessWidget {
  final Topic topic;

  const TopicDetails({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(topic.img),
          alignment: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 42,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TopicsScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset("assets/icons/arrow-left.svg"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 40,
              top: 7,
            ),
            child: Text(topic.title, style: myH1),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 40,
            ),
            child: Text(topic.titleRus, style: mySubtitle14Style),
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

class SubtopicsList extends StatelessWidget {
  final Topic topic;

  const SubtopicsList({
    Key key,
    this.topic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: topic.subtopics
            .map(
              (subtopic) => SubtopicContent(
                subtopic: subtopic,
                value: 0.5,
              ),
            )
            .toList(),
      ),
    );
  }
}

class SubtopicContent extends StatelessWidget {
  final Subtopic subtopic;
  final double value;

  const SubtopicContent({
    Key key,
    this.subtopic,
    this.value,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    int percentValue = (value * 100).toInt();

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => CardsPage(
              subtopic: subtopic,
            ),
          ),
        );
      },
      child: Ink(
        color: Colors.white,
        child: Padding(
          key: ValueKey(subtopic.title),
          padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 0.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              left: 0.0,
              right: 0.0,
            ),
            title: Text(
              subtopic.title,
              style: mySubtitle16Style,
            ),
            subtitle: Text(
              subtopic.titleRus,
              style: mySubtitle14Style,
            ),
            trailing: Container(
              width: 115,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    width: 85,
                    child: AnimatedProgressBar(
                      height: 3,
                      value: value,
                    ),
                  ),
                  Text(
                    percentValue.toString() + '%',
                    style: TextStyle(
                      fontSize: 12,
                      color: MyColors.subtitleColor,
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
