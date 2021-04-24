import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DB {
  static Future<bool> userExists(String userId) async {
    try {
      var collectionRef = Firestore.instance.collection('users');
      var doc = await collectionRef.document(userId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static void addNewUser(String userId) async {
    await Firestore.instance.collection("users").document(userId).setData({
      "premium": false,
      "eng_version": "br",
    });
  }

  static Future<List<String>> getEarlyLearnedCardsIDs(
      {String userId, String subtopicId}) async {
    try {
      List<String> learnedCards = List<String>();
      await Firestore.instance
          .collection('users/' + userId + '/learnedCards')
          .document(subtopicId)
          .get()
          .then((data) {
        if (data.exists) {
          learnedCards = data['learned_cards'].cast<String>();
        }
      }).catchError((e) => print("error fetching data: $e"));

      return learnedCards;
    } catch (e) {
      throw e;
    }
  }

  static void updateArrayOfLearnedCards(
      {String userId, String subtopicId, List<String> learnedCardsIDs}) async {
    await Firestore.instance
        .collection("users/" + userId + "/learnedCards")
        .document(subtopicId)
        .setData({
      "learned_cards": learnedCardsIDs,
    });
  }

  static Future<Map<String, dynamic>> getUserInfo(String userId) async {
    try {
      Map<String, dynamic> userInfo = Map<String, dynamic>();
      await Firestore.instance
          .collection('users')
          .document(userId)
          .get()
          .then((data) {
        if (data.exists) {
          userInfo = data.data;
        }
      }).catchError((e) => print("error fetching data: $e"));

      return userInfo;
    } catch (e) {
      throw e;
    }
  }  
  
  static Stream<Map<String, dynamic>> getUserInfoStream(String userId) async* {
    while (true) {
      yield await getUserInfo(userId);
    }
  }

  static Future<String> getUserEnglishVariant(FirebaseUser user) async {
    try {
      if (user == null) return "br";

      Map<String, dynamic> userInfo = Map<String, dynamic>();
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((data) {
        if (data.exists) {
          userInfo = data.data;
        }
      }).catchError((e) => print("error fetching data: $e"));

      return userInfo["eng_version"];
    } catch (e) {
      throw e;
    }
  }


  static void updateSubtopicsProgress(
      String userId, Map<String, String> subtopicsProgress) async {
    Map<String, dynamic> getUserInfo;
    getUserInfo = await DB.getUserInfo(userId);
    getUserInfo["subtopics_progress"] = subtopicsProgress;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .updateData(getUserInfo);
  }

  static void updateEnglishVariant(String userId, String englishVariant) async {
    Map<String, dynamic> getUserInfo;
    getUserInfo = await DB.getUserInfo(userId);
    getUserInfo["eng_version"] = englishVariant;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .updateData(getUserInfo);
  }
}
