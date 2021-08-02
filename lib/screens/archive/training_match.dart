import 'package:flutter/material.dart';
import 'dart:math';
import 'package:magicards/services/services.dart';
// import 'package:audioplayers/audio_cache.dart';

class TrainingMatch extends StatefulWidget {
  final List<Magicard> listOfCards;

  TrainingMatch({Key key, this.listOfCards}) : super(key: key);

  createState() => TrainingMatchState();
}

class TrainingMatchState extends State<TrainingMatch> {
  /// Map to keep track of score
  final Map<String, bool> score = {};

  // Random seed to shuffle order of items.
  int seed = 0;

  @override
  Widget build(BuildContext context) {
    Map<String, String> choices = {};

    for (var i = 0; i < widget.listOfCards.length; i++) {
      Magicard card = widget.listOfCards[i];
      choices[card.photo] = card.title;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${score.length} / ${choices.length}'),
      ),
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((cardImg) {
                return Draggable<String>(
                  data: cardImg,
                  child: CardImg(url: score[cardImg] == true ? '' : cardImg),
                  feedback: CardImg(url: cardImg),
                  childWhenDragging: CardImg(url: ''),
                );
              }).toList()),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys
                .map((cardImg) => _buildDragTarget(cardImg, choices[cardImg]))
                .toList()
                  ..shuffle(Random(seed)),
          )
        ],
      ),
    );
  }

  Widget _buildDragTarget(cardImg, cardWord) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[cardImg] == true) {
          return Container(
            color: Colors.lightBlue[300],
            child: Text('Correct!'),
            alignment: Alignment.center,
            height: 80,
            width: 150,
          );
        } else {
          return Column(
            children: <Widget>[
              Container(
                height: 80,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(cardWord),
                ),
              ),
            ],
          );
        }
      },
      onWillAccept: (data) => data == cardImg,
      onAccept: (data) {
        setState(() {
          score[cardImg] = true;
          // plyr.play('success.mp3');
        });
      },
      onLeave: (data) {},
    );
  }
}

class CardImg extends StatelessWidget {
  CardImg({Key key, this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        child: Image.network(url),
      ),
    );
  }
}

// AudioCache plyr = AudioCache();
