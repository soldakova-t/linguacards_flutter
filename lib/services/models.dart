import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Subtopic {
  String id;
  String title;
  String titleRus;

  Subtopic({
    this.id,
    this.title,
    this.titleRus,
  });

  factory Subtopic.fromMap(Map data) {
    return Subtopic(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      titleRus: data['titleRus'] ?? '',
    );
  }
}

class Topic {
  final String order;
  final String title;
  final String titleRus;
  final String img;
  final String imgPrev;
  final double imgPrevHeight;
  final String bgColor;
  final List<Subtopic> subtopics;
  final DocumentReference reference;

  Topic.fromMap(Map map, {this.reference})
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
            .map((v) => Subtopic.fromMap(v))
            .toList();

  Topic.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class Magicard {
  final String id;
  final String title;
  final String titleRus;
  final String transcription;
  final String photo;
  final String whiteBg;

  Magicard.fromMap(String docId, Map<String, dynamic> map)
      : assert(docId != null),
        assert(map['title'] != null),
        assert(map['photo'] != null),
        id = docId,
        title = map['title'],
        titleRus = map['titleRus'] ?? '',
        transcription = map['transcription'] ?? '',
        whiteBg = map['whiteBg'] ?? '1',
        photo = map['photo'];

  @override
  String toString() => "Magicard<$title>";
}

class TrainingFlashcardsState with ChangeNotifier {
  double _progress = 0;

  final PageController controller = PageController(
    viewportFraction: 0.9,
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
