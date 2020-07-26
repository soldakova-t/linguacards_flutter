import 'package:flutter/material.dart';
import 'package:magicards/shared/styles.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:magicards/shared/custom_icons_icons.dart';
import 'package:magicards/screens/training_flashcards.dart';
import '../services/services.dart';
import 'dart:async';

class RadialMenu extends StatefulWidget {
  RadialMenu(
      {Key key, this.listOfCards, this.listOfLearnedCards, this.subtopicId})
      : super(key: key);
  final List<Magicard> listOfCards;
  final List<String> listOfLearnedCards;
  final String subtopicId;

  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool isOpen = false; // Is not used

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                isOpen = true;
              });
            } else if (status == AnimationStatus.dismissed) {
              setState(() {
                isOpen = false;
              });
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(
      controller: controller,
      isOpen: isOpen,
      listOfCards: widget.listOfCards,
      listOfLearnedCards: widget.listOfLearnedCards,
      subtopicId: widget.subtopicId,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({
    Key key,
    this.controller,
    this.isOpen,
    this.listOfCards,
    this.listOfLearnedCards,
    this.subtopicId,
  })  : translation = Tween<double>(
          begin: 0.0,
          end: 70.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInQuad),
        ),
        scale = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.7,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;
  final bool isOpen;
  final List<Magicard> listOfCards;
  final List<String> listOfLearnedCards;
  final String subtopicId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 58,
        width: 58,
        child: FloatingActionButton(
          heroTag: "btnOpen",
          backgroundColor: MyColors.mainBrightColor,
          child: Center(
            child: Transform.rotate(
              // angle: -60,
              angle: 0,
              child: SizedBox(
                width: 42,
                child: Icon(
                  // CustomIcons.training,
                  CustomIcons.bottomnav_words,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onPressed: () {
            controller.forward();
            Future.delayed(Duration.zero, () {
              showDialog(
                  context: context,
                  builder: (context) => buildDialogButtons(listOfLearnedCards));
            });
          },
        ),
      ),
    );
  }

  AnimatedBuilder buildDialogButtons(List<String> listOfLearnedCards) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              controller.reverse();
            },
            child: Container(
              color: Color(0xE6FFFFFF),
              child: Padding(
                padding: const EdgeInsets.only(right: 32.0, bottom: 89.0),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    _buildButton(context, 2, 270, listOfLearnedCards,
                        color: Color(0xFF464EFF),
                        icon: CustomIcons.hidewords,
                        text: 'Скрыть английские слова'),
                    _buildButton(context, 1, 270, listOfLearnedCards,
                        color: Color(0xFF464EFF),
                        icon: CustomIcons.hideimages,
                        text: 'Скрыть изображения'),
                    Transform.scale(
                      scale: scale.value - 1,
                      child: SizedBox(
                        height: 58,
                        width: 58,
                        child: FloatingActionButton(
                          heroTag: "btnClose",
                          // backgroundColor: Color(0xFFF2F1F1),
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            color: Color(0xFF464EFF),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            controller.reverse();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _buildButton(BuildContext context, int number, double angle,
      List<String> listOfLearnedCards,
      {Color color, IconData icon, String text}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate((translation.value) * cos(rad),
            (translation.value * number) * sin(rad)),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 16.0, right: 8.0, bottom: 16.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 45,
                width: 45,
                child: FloatingActionButton(
                  heroTag: "subButton" + number.toString(),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                  backgroundColor: color,
                  onPressed: () {
                    _routeToTraining(context, number - 1);
                  },
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _routeToTraining(BuildContext context, int trainingVariant) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => TrainingFlashcards(
          listOfCards: listOfCards,
          listOfLearnedCards: listOfLearnedCards,
          trainingVariant: trainingVariant,
          subtopicId: subtopicId,
        ),
      ),
    );
  }
}
