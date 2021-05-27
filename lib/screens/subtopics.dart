import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

/*class SubtopicsScreen extends StatefulWidget {
  final Category topic;
  SubtopicsScreen({Key key, this.topic}) : super(key: key);

  @override
  _SubtopicsScreenState createState() => _SubtopicsScreenState();
}

class _SubtopicsScreenState extends State<SubtopicsScreen> {
  static const kExpandedHeight = 155.0;
  ScrollController _scrollController;
  Map<String, String> _userSubtopicsProgress = Map<String, String>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildSubtopicsList(context, _userSubtopicsProgress);
          } else {
            if (snapshot.data['subtopics_progress'] != null) {
              _userSubtopicsProgress =
                  Map<String, String>.from(snapshot.data['subtopics_progress']);
            }
            return _buildSubtopicsList(context, _userSubtopicsProgress);
          }
        },
      );
    } else {
      return _buildSubtopicsList(context, _userSubtopicsProgress);
    }
  }

  Scaffold _buildSubtopicsList(
      BuildContext context, Map<String, String> mapSubtopicsProgress) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: hexToColor('#B2B2B2'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            expandedHeight: kExpandedHeight + kToolbarHeight,
            title: _showTitle
                ? Text(
                    widget.topic.title,
                    style: myToolbarTextStyle,
                  )
                : null,
            flexibleSpace: _showTitle
                ? null
                : FlexibleSpaceBar(
                    background: TopicDetails(topic: widget.topic),
                  ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => SubtopicContent(
                  widget.topic.subtopics[index],
                  (mapSubtopicsProgress[widget.topic.subtopics[index].id] !=
                          null)
                      ? double.parse(mapSubtopicsProgress[
                          widget.topic.subtopics[index].id])
                      : 0.0,
                  mapSubtopicsProgress,
                ),
                childCount: widget.topic.subtopics.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
  }
}

class TopicDetails extends StatelessWidget {
  final Category topic;

  const TopicDetails({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              left: 40,
              top: 56 + kToolbarHeight,
            ),
            child: Container(
              width: 150,
              child: Text(
                topic.title,
                style: myH1,
              ),
            ),
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

class SubtopicContent extends StatelessWidget {
  final Topic subtopic;
  final double progress;
  final Map<String, String> mapSubtopicsProgress;

  const SubtopicContent(
    this.subtopic,
    this.progress,
    this.mapSubtopicsProgress, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int percentValue = (progress * 100).toInt();

    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      return StreamBuilder(
          stream: DB.getUserInfoStream(user.uid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> userInfo = snapshot.data;
              return buildSubtopicInnerContent(context, percentValue,
                  userInfo: userInfo);
            } else {
              return LinearProgressIndicator();
            }
          });
    } else {
      return buildSubtopicInnerContent(context, percentValue);
    }
  }

  InkWell buildSubtopicInnerContent(BuildContext context, int percentValue,
      {Map<String, dynamic> userInfo}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(_createRouteToCards(
            subtopic, mapSubtopicsProgress,
            userInfo: userInfo));
      },
      child: Ink(
        color: Colors.white,
        child: Padding(
          key: ValueKey(subtopic.title),
          padding: const EdgeInsets.only(left: 27.0, right: 8.0),
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
              width: 183,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 85,
                        child: AnimatedProgress(
                          height: 3,
                          value: progress,
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            percentValue.toString() + '%',
                            style: TextStyle(
                              fontSize: 12,
                              color: MyColors.subtitleColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  SvgPicture.asset("assets/icons/arrow_right.svg"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRouteToCards(
    Topic subtopic, Map<String, String> mapSubtopicsProgress,
    {Map<String, dynamic> userInfo}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CardsScreen(
      subtopic,
      mapSubtopicsProgress,
      userInfo: userInfo,
    ),
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
}*/
