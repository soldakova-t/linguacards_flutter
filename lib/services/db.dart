import 'package:cloud_firestore/cloud_firestore.dart';

class DB {
  static Future<bool> userExists([String phone, String email]) async {
    if (phone != null) {
      await Firestore.instance
          .collection("users")
          .where("phone", isEqualTo: phone)
          .getDocuments()
          .then((event) {})
          .catchError((e) => print("error fetching data: $e"));
    }
    return false;
  }

  static void addUser([String phone, String email]) async {
    await Firestore.instance.collection("users").add({
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      'preferences': {'premium': false, 'eng_version': 'br',},
    });
  }
}
