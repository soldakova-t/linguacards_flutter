import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:provider/provider.dart';
import 'shared/shared.dart';

void main() {
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
        StreamProvider<FirebaseUser>.value(value: AuthServiceFirebase().user),
        ChangeNotifierProvider<TrainingFlashcardsState>(
          create: (_) => TrainingFlashcardsState(),
        ),
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
            '/': (context) => TopicsScreen(),
            '/topics': (context) => TopicsScreen(),
            '/search': (context) => SearchScreen(),
            '/settings': (context) => SettingsScreen(),
          },

          // Theme
          theme: ThemeData(
            fontFamily: "SF Compact Display",
            primaryColor: MyColors.mainBrightColor,
            backgroundColor: MyColors.mainBgColor,
            brightness: Brightness.light,
            textTheme: TextTheme(
              bodyText2: myMainTextStyle, //"The default text style for Material."
              bodyText1: myMainTextStyle,
              button:
                  TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
              headline5: TextStyle(fontWeight: FontWeight.bold),
              subtitle1: TextStyle(fontWeight: FontWeight.bold),
            ),
            buttonTheme: ButtonThemeData(),
          ),
        ),
      ),
    );
  }
}
