import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({Key key, this.topics, this.title = ""}) : super(key: key);

  final List<Topic> topics;
  final String title;

  @override
  Widget build(BuildContext context) {
    return NetworkSensitive(
      child: Scaffold(
        extendBody: true, // For making BottomNavigationBar transparent.
        backgroundColor: MyColors.mainBgColor,
        body: _buildBody(context),
        appBar: AppBar(
          elevation: 0, // Removes status bar's shadow.
          backgroundColor: MyColors.mainBgColor,
          title: Text(title),
        ),
        bottomNavigationBar: AppBottomNav(
          selectedIndex: 1,
          isHomePage: false,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: convertHeightFrom360(context, 360, 16)),
          TopicsList(topics: topics),
          SizedBox(height: convertHeightFrom360(context, 360, 80)),
        ],
      ),
    );
  }
}
