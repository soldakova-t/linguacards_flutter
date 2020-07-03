import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magicards/shared/custom_icons_icons.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10.0, ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('assets/icons/logo.svg'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, ),
                child: Text('Magicards'),
              ),
            ],
          ),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: hexToColor('#393560'),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: AppBottomNav(selectedIndex: 0, isHomePage: true,),
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
          return _buildTopicList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildTopicList(BuildContext context, List<DocumentSnapshot> snapshot) {
    Queue<Topic> topics = new Queue<Topic>();

    for (var i = 0; i < snapshot.length; i++) {
      DocumentSnapshot topicSnapshot = snapshot[i];
      Topic topic = Topic.fromSnapshot(topicSnapshot);
      topics.add(topic);
    }

    return Container(
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20, ),
        crossAxisCount: 2,
        itemCount: topics.length,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        itemBuilder: (context, index) {
          return _buildTopicListItem(context, topics.removeFirst(), index);
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      ),
    );
  }

  Widget _buildTopicListItem(BuildContext context, Topic topic, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute(topic));
      },
      child: Container(
        height: index.isEven ? 200 : 240,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: hexToColor(topic.bgColor),
            image: DecorationImage(
              image: NetworkImage(topic.imgPrev),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomRight,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    topic.title,
                    style: myH2,
                  ),
                  Text(
                    topic.titleRus,
                    style: mySubtitle14Style,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute(Topic topic) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SubtopicsScreen(topic: topic),
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