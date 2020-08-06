import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubtopicsScreen extends StatefulWidget {
  final Topic topic;
  SubtopicsScreen({Key key, this.topic}) : super(key: key);

  @override
  _SubtopicsScreenState createState() => _SubtopicsScreenState();
}

class _SubtopicsScreenState extends State<SubtopicsScreen> {
  static const kExpandedHeight = 155.0;
  ScrollController _scrollController;
  Map<String, String> _mapSubtopicsProgress;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _mapSubtopicsProgress = Map<String, String>();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      print(user.uid);
      return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildSubtopicsList(context, _mapSubtopicsProgress);
          } else {
              _mapSubtopicsProgress =
                  Map<String, String>.from(snapshot.data['subtopics_progress']);
            return _buildSubtopicsList(context, _mapSubtopicsProgress);
          }
        },
      );
    } else {
      return _buildSubtopicsList(context, _mapSubtopicsProgress);
    }
  }

  Scaffold _buildSubtopicsList(
      BuildContext context, Map<String, String> mapSubtopicsProgress) {
    print('mapSubtopicsProgress = ');

    mapSubtopicsProgress.forEach((key, value) {
      print(key + ' => ' + value);
    });

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
                  subtopic: widget.topic.subtopics[index],
                  progress:
                      (mapSubtopicsProgress[widget.topic.subtopics[index].id] !=
                              null)
                          ? double.parse(mapSubtopicsProgress[
                              widget.topic.subtopics[index].id])
                          : 0.0,
                  mapSubtopicsProgress: mapSubtopicsProgress,
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
  final Topic topic;

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
  final Subtopic subtopic;
  final double progress;
  final Map<String, String> mapSubtopicsProgress;

  const SubtopicContent({
    Key key,
    this.subtopic,
    this.progress,
    this.mapSubtopicsProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int percentValue = (progress * 100).toInt();

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(_createRoute(subtopic, mapSubtopicsProgress));
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
              width: 121,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    width: 85,
                    child: AnimatedProgress(
                      height: 3,
                      value: progress,
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

Route _createRoute(
    Subtopic subtopic, Map<String, String> mapSubtopicsProgress) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CardsScreen(
      subtopic: subtopic,
      mapSubtopicsProgress: mapSubtopicsProgress,
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
}
