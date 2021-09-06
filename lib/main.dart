import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:magicards/api/purchase_api.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:provider/provider.dart';
import 'shared/shared.dart';
import 'enums/connectivity_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PurchaseApi.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: MyColors.mainBgColor,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<User>.value(value: AuthServiceFirebase().user),
          StreamProvider<Sale>.value(value: DB.getSaleStream()),
          StreamProvider<StringsFB>.value(value: DB.getStringsFBStream()),
          StreamProvider<ConnectivityStatus>(
              create: (_) =>
                  ConnectivityService().connectionStatusController.stream),
          Provider<LearningState>(create: (_) => LearningState()),
          ChangeNotifierProvider<TrainingState>(create: (_) => TrainingState()),
          ChangeNotifierProvider<RevenueCatProvider>(
              create: (_) => RevenueCatProvider()),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: MaterialApp(
            // Firebase Analytics
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
            ],

            // Named Routes
            routes: {
              '/': (context) => MainScreen(),
              '/main': (context) => MainScreen(),
              '/words': (context) => CategoriesScreen(),
              '/settings': (context) => SettingsScreen(),
              '/login': (context) => LoginScreen(),
            },

            // Theme
            theme: ThemeData(
              fontFamily: "SF Compact Display",
              primaryColor: MyColors.mainBrightColor,
              backgroundColor: MyColors.mainBgColor,
              canvasColor: Colors.transparent,
              brightness: Brightness.light,
              textTheme: TextTheme(
                bodyText2:
                    myMainTextStyle, //"The default text style for Material."
                bodyText1: myMainTextStyle,
                headline5: TextStyle(fontWeight: FontWeight.bold),
                subtitle1: TextStyle(fontWeight: FontWeight.bold),
              ),
              buttonTheme: ButtonThemeData(),
            ),
          ),
        ));
  }
}
