import 'package:cloud_firestore/cloud_firestore.dart';

class DB {
  static Future<bool> userExists({String phone, String socialId}) async {
    try {
      var docs;

      if (phone != null) {
        docs = await Firestore.instance
            .collection("users")
            .where("phone", isEqualTo: phone)
            .getDocuments();
      } else if (socialId != null) {
        docs = await Firestore.instance
            .collection("users")
            .where("socialId", isEqualTo: socialId)
            .getDocuments();
      } else {
        return false;
      }

      int numberOfDocs = docs.documents.toList().length;
      return (numberOfDocs > 0);
    } catch (e) {
      throw e;
    }
  }

  static void addUser({String phone, String socialId}) async {
    await Firestore.instance.collection("users").add({
      if (phone != null) 'phone': phone,
      if (socialId != null) 'socialId': socialId,
      'preferences': {
        'premium': false,
        'eng_version': 'br',
      },
    });
  }
}
