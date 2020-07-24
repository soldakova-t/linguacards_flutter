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

  static Future<List<String>> getEarlyLearnedCards(
      {String userId, String subtopicId}) async {
    try {
      List<String> learnedCards = List<String>();

      /*var learnedcardsQuery = Firestore.instance
          .collection('users/' + userId.toString() + '/learnedCards')
          .where('subtopic_id', isEqualTo: subtopicId)
          .limit(1);
          
        await learnedcardsQuery.getDocuments().then((data) {
        if (data.documents.length > 0) {
          learnedCards = data.documents[0].data['learned_cards'].cast<String>();
        }
      });*/

      await Firestore.instance
          .collection('users/' + userId.toString() + '/learnedCards')
          .document(subtopicId)
          .get()
          .then((data) {
        if (data.exists) {
          learnedCards = data['learned_cards'].cast<String>();
        }
      }).catchError((e) => print("error fetching data: $e"));

      // learnedCards.forEach((element) { print('getEarlyLearnedCards ' + element); });
      
      return learnedCards;
    } catch (e) {
      throw e;
    }
  }

  static void updateArrayOfLearnedCards(
      {String userId, String subtopicId, List<String> learnedCards}) async {
    await Firestore.instance
        .collection("users/" + userId + "/learnedCards")
        .document(subtopicId)
        .setData({
      "learned_cards": learnedCards,
    });
  }
}
