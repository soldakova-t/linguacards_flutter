import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magicards/shared/custom_icons_icons.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<Topic> _topics = [];
  List<Subtopic> _popularSubtopics = [];
  Map<String, String> _userAllSubtopicsProgress = Map<String, String>();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      extendBody: true, // for making BottomNavigationBar transparent
      backgroundColor: MyColors.mainBgColor,
      body: _buildBody(context),
      appBar: AppBar(
        elevation: 0, // Removes status bar's shadow.
        toolbarHeight: 0,
      ),
      bottomNavigationBar: AppBottomNav(selectedIndex: 0, isHomePage: true),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          Firestore.instance.collection('topics').orderBy('order').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: convertHeightFrom360(context, 360, 16)),
                _buildTopBar(context),
                SizedBox(height: convertHeightFrom360(context, 360, 33)),
                _buildTitleAndShowAll(context, "Добро пожаловать!"),
                SizedBox(height: convertHeightFrom360(context, 360, 12)),
                _buildGreeting(context),
                SizedBox(height: convertHeightFrom360(context, 360, 42)),
                _buildTitleAndShowAll(context, "Категории",
                    showButtonAll: true),
                SizedBox(height: convertHeightFrom360(context, 360, 16)),
                _buildTopicList(context, snapshot.data.documents),
                SizedBox(height: convertHeightFrom360(context, 360, 42)),
                _buildTitleAndShowAll(context, "Популярные темы"),
                SizedBox(height: convertHeightFrom360(context, 360, 16)),
                _buildPopularSubtopicsList(context),
                SizedBox(height: convertHeightFrom360(context, 360, 80)),
              ],
            ),
          );
        }
      },
    );
  }

  Padding _buildGreeting(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: convertWidthFrom360(context, 16)),
      child: Row(
        children: [
          Text("Выберите тему и приступайте к изучению "),
          Container(
              width: 12,
              height: 12,
              child: SvgPicture.asset('assets/icons/rocket.svg')),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(
          left: convertWidthFrom360(context, 16), top: statusBarHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/icons/logo.svg'),
          Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 8.0,
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'lingvi', style: myLogoStyle),
                    TextSpan(text: 'cards', style: myLogoStyle),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTitleAndShowAll(BuildContext context, String title,
      {bool showButtonAll = false, String ref}) {
    return Container(
      padding: EdgeInsets.only(left: convertWidthFrom360(context, 16)),
      height: 25,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: convertWidthFrom360(context, 240),
                child: Text(title, style: myHeaderStyle),
              ),
            ),
          ),
          if (showButtonAll == true)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(_createRouteToTopics());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: convertWidthFrom360(context, 16),
                      vertical: convertHeightFrom360(context, 360, 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Показать все",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: MyColors.mainBrightColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopicList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    _topics.clear();
    _popularSubtopics.clear();
    for (var i = 0; i < snapshot.length; i++) {
      // Filling Queue<Topics> _topics.
      DocumentSnapshot topicSnapshot = snapshot[i];
      Topic topic = Topic.fromSnapshot(topicSnapshot);
      _topics.add(topic);

      // Filling List<Subtopic> _popularSubtopics.
      for (var i = 0; i < topic.subtopics.length; i++) {
        if (topic.subtopics[i].popular)
          _popularSubtopics.add(topic.subtopics[i]);
      }
    }

    double categoryHeight = convertHeightFrom360(context, 140, 198);

    return Container(
      height: categoryHeight,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _topics.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildTopicListItem(context, _topics[index], index);
          }),
    );
  }

  Widget _buildPopularSubtopicsList(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: convertWidthFrom360(context, 16)),
      child: ColumnBuilder(
          itemCount: _popularSubtopics.length,
          itemBuilder: (BuildContext context, int index) {
            if (user != null) {
              return StreamBuilder(
                stream: DB.getUserInfoStream(user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> userInfo = snapshot.data;
                    return _buildPopularSubtopicsListItem(context, index,
                        userInfo: userInfo);
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return _buildPopularSubtopicsListItem(context, index);
            }
          }),
    );
  }

  Widget _buildPopularSubtopicsListItem(BuildContext context, int index,
      {Map<String, dynamic> userInfo}) {
    double progress = (userInfo["subtopics_progress"][_popularSubtopics[index].id] !=
            null)
        ? double.parse(userInfo["subtopics_progress"][_popularSubtopics[index].id])
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: convertHeightFrom360(context, 360, 16)),
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
            Positioned(
              left: convertWidthFrom360(context, 16),
              top: convertHeightFrom360(context, 360, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_popularSubtopics[index].title, style: myTitleStyle),
                  SizedBox(height: convertHeightFrom360(context, 360, 5)),
                  Text(_popularSubtopics[index].titleRus,
                      style: mySubtitleStyle),
                  SizedBox(height: convertHeightFrom360(context, 360, 17)),
                  Container(
                    width: convertWidthFrom360(context, 112),
                    child: AnimatedProgressWithDelay(
                      height: convertHeightFrom360(context, 360, 3),
                      value: progress,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: convertWidthFrom360(context, -8),
              top: convertHeightFrom360(context, 360, 32),
              child: Container(
                width: convertWidthFrom360(context, 66),
                height: convertHeightFrom360(context, 360, 66),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(_popularSubtopics[index].imgPrev),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicListItem(BuildContext context, Topic topic, int index) {
    double categoryWidth = convertWidthFrom360(context, 140);
    double leftPadding = 0;

    if (index == 0) leftPadding = convertWidthFrom360(context, 16);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRouteToTopic(topic));
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: leftPadding, right: convertWidthFrom360(context, 16)),
        child: Stack(
          children: [
            Container(
              width: categoryWidth,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(convertWidthFrom360(context, 16)),
                color: hexToColor(topic.bgColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(convertWidthFrom360(context, 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          topic.title,
                          style: myTitleStyle,
                        ),
                        SizedBox(height: convertHeightFrom360(context, 360, 5)),
                        Text(
                          topic.titleRus,
                          style: mySubtitleStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: convertWidthFrom360(context, 16),
              bottom: 0,
              child: Container(
                width: convertWidthFrom360(context, 76),
                height: convertHeightFrom360(context, 76, 104),
                alignment: Alignment.bottomRight,
                child: Image.network(topic.imgPrev),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRouteToTopic(Topic topic) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SubtopicsScreen(topic: topic),
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
}

Route _createRouteToTopics() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
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
}
