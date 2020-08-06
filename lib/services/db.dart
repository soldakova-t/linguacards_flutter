import 'package:cloud_firestore/cloud_firestore.dart';

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
      'preferences': {
        'premium': false,
        'eng_version': 'br',
      },
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

  static void updateSubtopicsProgress(
      {String userId, Map<String, String> subtopicsProgress}) async {
    await Firestore.instance.collection("users").document(userId).setData({
      "subtopics_progress": subtopicsProgress,
    });
  }
}
