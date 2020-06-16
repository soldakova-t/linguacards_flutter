import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magicards/services/services.dart';

class Subtopic { 
  String title;
  String titleRus;

  Subtopic({ this.title, this.titleRus, });

  factory Subtopic.fromMap(Map data) {
    return Subtopic(
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
        subtopics = (map['subtopics'] as List ?? []).map((v) => Subtopic.fromMap(v)).toList();

  Topic.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}

class Magicard {
  final String title;
  final String titleRus;
  final String photo;
  final DocumentReference reference;

  Magicard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['photo'] != null),
        title = map['title'],
        titleRus = map['titleRus'] ?? '',
        photo = map['photo'];

  Magicard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Magicard<$title:$photo>";
}