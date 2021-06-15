import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Topic {
  String id;
  String title;
  String titleRus;
  final String img;
  final String imgPrev;
  bool premiumAccess;
  bool popular;

  Topic(
      {this.id,
      this.title,
      this.titleRus,
      this.img,
      this.imgPrev,
      this.premiumAccess,
      this.popular});

  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      titleRus: data['titleRus'] ?? '',
      img: data['img'] ?? '',
      imgPrev: data['imgPrev'] ?? '',
      premiumAccess: data['premiumAccess'] ?? false,
      popular: data['popular'] ?? false,
    );
  }
}

class Category {
  final String order;
  final String title;
  final String titleRus;
  final String img;
  final String imgPrev;
  final double imgPrevHeight;
  final String bgColor;
  final List<Topic> subtopics;
  final DocumentReference reference;

  Category.fromMap(Map map, {this.reference})
      : assert(map['order'] != null),
        assert(map['title'] != null),
        assert(map['titleRus'] != null),
        assert(map['img'] != null),
        assert(map['imgPrev'] != null),
        assert(map['imgPrevHeight'] != null),
        assert(double.parse(map['imgPrevHeight']) is double),
        assert(map['bgColor'] != null),
        order = map['order'],
        title = map['title'],
        titleRus = map['titleRus'],
        img = map['img'],
        imgPrev = map['imgPrev'],
        imgPrevHeight = double.parse(map['imgPrevHeight']),
        bgColor = map['bgColor'],
        subtopics = (map['subtopics'] as List ?? [])
            .map((v) => Topic.fromMap(v))
            .toList();

  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

/* class Magicard {
  final String id;
  final String title;
  final String titleRus;
  final String transcription;
  final String photo;
  final String whiteBg;
  final String level;
  final Map<String, dynamic> sound;
  final DocumentReference reference;

  Magicard.fromMap(String cardId, Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['photo'] != null),
        id = cardId,
        title = map['title'],
        titleRus = map['titleRus'] ?? '',
        transcription = map['transcription'] ?? '',
        whiteBg = map['whiteBg'] ?? '1',
        level = map['level'] ?? 'A1 - A2',
        photo = map['photo'],
        sound = map['sound'] ?? Map<String, String>();

  Magicard.fromSnapshot(String cardId, DocumentSnapshot snapshot)
      : this.fromMap(cardId, snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Magicard<$title>";
}*/

class Magicard {
  final String id;
  final String number;
  final String title;
  final String titleRus;
  final String transcriptionBr;
  final String photo;
  final String level;
  final Map<String, dynamic> sound;
  final DocumentReference reference;

  Magicard.fromMap(String cardId, Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        id = cardId,
        title = map['title'],
        number = map['number'],
        titleRus = map['titleRus'] ?? '',
        transcriptionBr = map['transcription_br'] ?? '',
        level = map['level'] ?? 'A1 - A2',
        photo = map['photo'] ?? '',
        sound = map['sound'] ?? Map<String, String>();

  Magicard.fromSnapshot(String cardId, DocumentSnapshot snapshot)
      : this.fromMap(cardId, snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "<$title> <$number>";
}

class TrainingFlashcardsState with ChangeNotifier {
  double _progress = 0;

  final PageController controller = PageController(
    viewportFraction: 1.0, // Was 0.9.
    initialPage: 0,
  );

  get progress => _progress;

  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  void nextPage() async {
    await controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void prevPage() async {
    await controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}

/*class User with ChangeNotifier {
  String userId;
  String userEngVersion;
  String userPremium;
  Map userSubtopicsProgress;

  get id => userId;

  set id (String newValue) {
    userId = newValue;
    notifyListeners();
  }

  get engVersion => userId;

  set engVersion (String newValue) {
    userId = newValue;
    notifyListeners();
  }

  get premium => userId;

  set premium (String newValue) {
    userId = newValue;
    notifyListeners();
  }

  get subtopicsProgress => userId;

  set subtopicsProgress (String newValue) {
    userId = newValue;
    notifyListeners();
  }

  User({
    this.userId,
    this.userEngVersion,
    this.userPremium,
    this.userSubtopicsProgress,
  });

  factory User.fromMap(Map data) {
    return User(
      userId: data['id'] ?? '',
      userEngVersion: data['eng_version'] ?? '',
      userPremium: data['premium'] ?? '',
      userSubtopicsProgress: data['subtopics_progress'] ?? '',
    );
  }
}*/
