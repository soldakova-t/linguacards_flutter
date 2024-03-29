import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magicards/services/services.dart';

class DB {
  static Future<Sale> getSale() async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('settings');
      var doc = await collectionRef.doc('sale').get();
      Sale sale;
      if (doc.exists) return sale = Sale.fromSnapshot(doc);
      return sale;
    } catch (e) {
      throw e;
    }
  }

  static Stream<Sale> getSaleStream() async* {
    while (true) {
      yield await getSale();
    }
  }

  static Future<StringsFB> getStringsFB() async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('settings');
      var doc = await collectionRef.doc('strings').get();
      StringsFB stringsFB;
      if (doc.exists) return stringsFB = StringsFB.fromSnapshot(doc);
      return stringsFB;
    } catch (e) {
      throw e;
    }
  }

  static Stream<StringsFB> getStringsFBStream() async* {
    while (true) {
      yield await getStringsFB();
    }
  }

  static Future<bool> userExists(String userId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var doc = await collectionRef.doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static void addNewUser(String userId) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).set({
      "premium": false,
      "eng_version": "br",
    });
  }

  /*static Stream<List<String>> getEarlyLearnedCardsIDs(
      {String userId, String subtopicId}) async* {
    try {
      //List<String> learnedCards = List<String>();
      yield await FirebaseFirestore.instance
          .collection('users/' + userId + '/learnedCards')
          .doc(subtopicId)
          .get()
          .then((data) {
        if (data.exists) {
          return data['learned_cards'].cast<String>();
        }
      }).catchError((e) => print("error fetching data: $e"));

      //return learnedCards;
    } catch (e) {
      throw e;
    }
  }*/

  static Future<List<String>> getEarlyLearnedCardsIDs(
      String userId, String subtopicId) async {
    try {
      List<String> learnedCards = [];
      await FirebaseFirestore.instance
          .collection('users/' + userId + '/learnedCards')
          .doc(subtopicId)
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

  static Stream<List<String>> getEarlyLearnedCardsIDsStream(
      String userId, String subtopicId) async* {
    while (true) {
      yield await getEarlyLearnedCardsIDs(userId, subtopicId);
    }
  }

  static void updateArrayOfLearnedCards(
      {String userId, String subtopicId, List<String> learnedCardsIDs}) async {
    await FirebaseFirestore.instance
        .collection("users/" + userId + "/learnedCards")
        .doc(subtopicId)
        .set({
      "learned_cards": learnedCardsIDs,
    });
  }

  static Future<Map<String, dynamic>> getUserInfo(String userId) async {
    try {
      Map<String, dynamic> userInfo = Map<String, dynamic>();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((data) {
        if (data.exists) {
          userInfo = data.data();
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

  static Future<String> getUserEnglishVariant(User user) async {
    try {
      if (user == null) return "br";

      Map<String, dynamic> userInfo = Map<String, dynamic>();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((data) {
        if (data.exists) {
          userInfo = data.data();
        }
      }).catchError((e) => print("error fetching data: $e"));

      return userInfo["eng_version"];
    } catch (e) {
      throw e;
    }
  }

  static void updateTopicsNumbersLearnedCards(
      String userId, Map<String, int> topicsNumbersLearnedCards) async {
    Map<String, dynamic> getUserInfo;
    getUserInfo = await DB.getUserInfo(userId);
    getUserInfo["topics_numbers_learned_cards"] = topicsNumbersLearnedCards;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(getUserInfo);
  }

  static void updateEnglishVariant(String userId, String englishVariant) async {
    Map<String, dynamic> getUserInfo;
    getUserInfo = await DB.getUserInfo(userId);
    getUserInfo["eng_version"] = englishVariant;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(getUserInfo);
  }
}
