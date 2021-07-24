import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Topic {
  String categoryNumber;
  String number;
  String id;
  String title;
  String titleRus;
  bool premiumAccess;
  bool popular;
  int numberOfCards;

  Topic(
      {this.categoryNumber,
      this.number,
      this.id,
      this.title,
      this.titleRus,
      this.premiumAccess,
      this.popular,
      this.numberOfCards});

  factory Topic.fromMap(Map data) {
    return Topic(
      categoryNumber: data['categoryNumber'] ?? '',
      number: data['number'] ?? '',
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      titleRus: data['titleRus'] ?? '',
      premiumAccess: data['premiumAccess'] ?? false,
      popular: data['popular'] ?? false,
      numberOfCards: data['numberOfCards'] ?? 1,
    );
  }
}

class Category {
  final String number;
  final String title;
  final String titleRus;
  final double photoRightPadding;
  final double photoBottomPadding;
  final double photoHeight;
  final String bgColor;
  final List<Topic> subtopics;
  final DocumentReference reference;

  Category.fromMap(Map map, {this.reference})
      : assert(map['number'] != null),
        assert(map['title'] != null),
        assert(map['titleRus'] != null),  
        assert(map['bgColor'] != null),
        assert(map['photoRightPadding'] != null),
        assert(map['photoBottomPadding'] != null),  
        assert(map['photoHeight'] != null),
        number = map['number'],
        title = map['title'],
        titleRus = map['titleRus'],
        photoRightPadding = double.parse(map['photoRightPadding']) ?? 8,
        photoBottomPadding = double.parse(map['photoBottomPadding']) ?? 0,
        photoHeight = double.parse(map['photoHeight']) ?? 104,
        bgColor = map['bgColor'],
        subtopics = (map['subtopics'] as List ?? [])
            .map((v) => Topic.fromMap(v))
            .toList();

  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
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
  final String subtopic;
  final String number;
  final String title;
  final String titleRus;
  final String transcriptionBr;
  final String photo;
  final String level;
  final Map<String, dynamic> sound;
  final String partOfSpeech;
  final String syn1;
  final String syn2;
  final String example1;
  final String example2;
  final DocumentReference reference;

  Magicard.fromMap(String cardId, Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        id = cardId,
        subtopic = map['subtopic'],
        number = map['number'],
        title = map['title'],
        titleRus = map['titleRus'] ?? '',
        transcriptionBr = map['transcription_br'] ?? '',
        level = map['level'] ?? 'A1 - A2',
        photo = map['photo'] ?? '',
        sound = map['sound'] ?? Map<String, String>(),
        partOfSpeech = map['partOfSpeech'] ?? 'noun',
        syn1 = map['syn1'] ?? '',
        syn2 = map['syn2'] ?? '',
        example1 = map['example1'] ?? '',
        example2 = map['example2'] ?? '';

  Magicard.fromSnapshot(String cardId, DocumentSnapshot snapshot)
      : this.fromMap(cardId, snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "<$title> <$number>";
}

class LearningState {
  Map<String, int> topicsNumbersLearnedCards = {};
  Topic topic;
  int numberOfCardsInTopic = 1;
  List<Magicard> cardsForTraining = [];
  List<String> listLearnedCardsIDs = [];
  Magicard card;
}

class TrainingState with ChangeNotifier {
  double _trainingProgress = 0;
  int _currentCardNumber = 1;

  final PageController controller = PageController(
    viewportFraction: 1.0, // Was 0.9.
    initialPage: 0,
  );

  get trainingProgress => _trainingProgress;
  get currentCardNumber => _currentCardNumber;

  set trainingProgress(double newValue) {
    _trainingProgress = newValue;
    notifyListeners();
  }

  set currentCardNumber(int newValue) {
    _currentCardNumber = newValue;
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
