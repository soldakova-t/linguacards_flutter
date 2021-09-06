import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class PopularTopicsScreen extends StatefulWidget {
  const PopularTopicsScreen({Key key, this.topics, this.title = ""})
      : super(key: key);

  final List<Topic> topics;
  final String title;

  @override
  _PopularTopicsScreenState createState() => _PopularTopicsScreenState();
}

class _PopularTopicsScreenState extends State<PopularTopicsScreen> {
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
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.mainBgColor,
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          selectedIndex: 0,
          isHomePage: true,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: convertHeightFrom360(context, 360, 16)),
          TopicsList(
            topics: widget.topics,
            showOffering: false,
            showPopulars: false,
          ),
          SizedBox(height: convertHeightFrom360(context, 360, 80)),
        ],
      ),
    );
  }
}
