import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:audioplayers/audioplayers.dart';

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
