import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Category> categories = [];
  List<Topic> popularTopics = [];
  List<Topic> threePopularTopics = [];
  User user;
  Map<String, String> userAllTopicsProgress = Map<String, String>();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return Scaffold(
      extendBody: true, // For making BottomNavigationBar transparent.
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
          FirebaseFirestore.instance.collection('topics').orderBy('number').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          categories.clear();
          popularTopics.clear();
          threePopularTopics.clear();

          for (var i = 0; i < snapshot.data.docs.length; i++) {
            // Filling List<Category> categories.
            DocumentSnapshot categorySnapshot = snapshot.data.docs[i];
            Category category = Category.fromSnapshot(categorySnapshot);
            categories.add(category);

            // Filling List<Topic> popularTopics and threePopularTopics.
            for (var i = 0; i < category.subtopics.length; i++) {
              if (category.subtopics[i].popular) {
                popularTopics.add(category.subtopics[i]);
                if (threePopularTopics.length < 3) threePopularTopics.add(category.subtopics[i]);
              }
            }
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: convertHeightFrom360(context, 360, 16)),
                _buildCustomTopBar(context),
                SizedBox(height: convertHeightFrom360(context, 360, 33)),
                TitleAndShowAll(title: "Добро пожаловать!"),
                SizedBox(height: convertHeightFrom360(context, 360, 12)),
                _buildGreeting(context),
                SizedBox(height: convertHeightFrom360(context, 360, 42)),
                TitleAndShowAll(
                    title: "Категории",
                    showButtonAll: true,
                    ref: "/categories"),
                SizedBox(height: convertHeightFrom360(context, 360, 16)),
                CategoriesList(
                    categories: categories, orientation: "horizontal"),
                SizedBox(height: convertHeightFrom360(context, 360, 42)),
                TitleAndShowAll(
                    title: "Популярные темы",
                    showButtonAll: true,
                    ref: "/popular_topics",
                    passedTopics: popularTopics,
                    passedTitle: "Популярные темы"),
                SizedBox(height: convertHeightFrom360(context, 360, 16)),
                TopicsList(topics: threePopularTopics),
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

  Widget _buildCustomTopBar(BuildContext context) {
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
}
