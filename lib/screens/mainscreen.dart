import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicards/api/purchase_api.dart';
import 'package:magicards/enums/entitlement.dart';
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

    return NetworkSensitive(
      child: Scaffold(
        extendBody: true, // For making BottomNavigationBar transparent.
        backgroundColor: MyColors.mainBgColor,
        body: _buildBody(context),
        appBar: AppBar(
          elevation: 0, // Removes status bar's shadow.
          toolbarHeight: 0,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.mainBgColor,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        bottomNavigationBar: AppBottomNav(selectedIndex: 0, isHomePage: true),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('topics')
          .orderBy('number')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgress();
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
                if (threePopularTopics.length < 3)
                  threePopularTopics.add(category.subtopics[i]);
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
                TopicsList(
                  topics: threePopularTopics,
                  showOffering: false,
                  showPopulars: false,
                ),
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
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    double appBarHeight;
    (entitlement == Entitlement.premium)
        ? appBarHeight = 45
        : appBarHeight = 55;

    bool showSaleMessage = false;
    Sale sale = Provider.of<Sale>(context);
    if (sale != null) {
      showSaleMessage = sale.active;
    }

    return Container(
      width: double.infinity,
      height: convertHeightFrom360(context, 360, appBarHeight),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: convertWidthFrom360(context, 16),
                top: statusBarHeight + 10),
            child: SvgPicture.asset('assets/icons/logo.svg'),
          ),
          (entitlement != Entitlement.premium)
              ? Positioned(
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: convertWidthFrom360(context, 16),
                        top: statusBarHeight + 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            fetchOffers(context, user);
                          },
                          child: Container(
                            height: convertHeightFrom360(context, 360, 22),
                            width: convertWidthFrom360(context, 74),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF656565)),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    convertWidthFrom360(context, 6)),
                              ),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text("плюс",
                                  style: myAppBarPremiumLabelStyle),
                            ),
                          ),
                        ),
                        SizedBox(height: convertHeightFrom360(context, 360, 7)),
                        showSaleMessage
                            ? Text(sale.message, style: mySaleLabelStyle)
                            : Container(),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
