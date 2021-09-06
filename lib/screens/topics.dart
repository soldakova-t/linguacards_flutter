import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicards/api/purchase_api.dart';
import 'package:magicards/enums/entitlement.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen(this.topics, this.title, this.premium, {Key key})
      : super(key: key);

  final List<Topic> topics;
  final String title;
  final bool premium;

  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      User user = Provider.of<User>(context, listen: false);
      if (widget.premium) {
        final entitlement =
            Provider.of<RevenueCatProvider>(context, listen: false).entitlement;

        if (entitlement == Entitlement.free) {
          fetchOffers(context, user);
        }
      }
    });
  }

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
          selectedIndex: 1,
          isHomePage: false,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    bool showOffering = true;
    final entitlement =
        Provider.of<RevenueCatProvider>(context, listen: false).entitlement;
    if (widget.premium == false || entitlement == Entitlement.premium)
      showOffering = false;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: convertHeightFrom360(context, 360, 16)),
          TopicsList(
            topics: widget.topics,
            showOffering: showOffering,
          ),
          SizedBox(height: convertHeightFrom360(context, 360, 80)),
        ],
      ),
    );
  }
}
