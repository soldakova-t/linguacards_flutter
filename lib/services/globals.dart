import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:magicards/screens/screens.dart';
import 'models.dart';

/// Static global state. Immutable services that do not care about build context.
class Globals {
  // App Data
  static final String title = 'Magicards';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  static playPronounciation(String url) async {
    if (url != null && url != "") {
      AudioPlayer audioPlayer = AudioPlayer();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        // success
      }
    }
  }
}

String capitalize(String s) {
  if (s == "") {
    return "";
  } else {
    return s[0].toUpperCase() + s.substring(1);
  }
}

double convertWidthFrom360(BuildContext context, double blockWidth) {
  final mediaQuery = MediaQuery.of(context);
  final newBlockWidth = mediaQuery.size.width * blockWidth / 360;
  return newBlockWidth;
}

double convertHeightFrom360(
    BuildContext context, double blockWidth, double blockHeight) {
  final mediaQuery = MediaQuery.of(context);
  final newBlockWidth = mediaQuery.size.width * blockWidth / 360;
  final newBlockHeight = blockHeight *
      newBlockWidth /
      blockWidth; // Height is proportional to width
  return newBlockHeight;
}

Route createRouteScreen(String ref,
    {List<Topic> topics, String title}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      if (ref == "/categories") {
        return CategoriesScreen();
      }
      if (ref == "/topics" && topics != null) {
        return TopicsScreen(
          topics: topics,
          title: title,
        );
      }
      if (ref == "/popular_topics") {
        return PopularTopicsScreen(
          topics: topics,
          title: title,
        );
      }
      if (ref == "/cards") {
        return CardsScreen();
      }
      return CategoriesScreen();
    },
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

