import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:magicards/screens/training_flashcards.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class CardDetailsScreen extends StatelessWidget {
  const CardDetailsScreen({Key key, this.card, this.listLearnedCardsIDs, this.subtopicId, this.mapSubtopicsProgress, this.numberOfCardsInSubtopic}) : super(key: key);
  final Magicard card;
  final List<String> listLearnedCardsIDs;
  final String subtopicId;
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: hexToColor('#B2B2B2'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Stack(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 30),
                  child: Text(
                    card.title,
                    style: myH1Card,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '[' + card.transcription + ']',
                        style: myTranscriptionCard,
                      ),
                      SizedBox(width: 10),
                      ClipOval(
                        child: Container(
                          height: 30,
                          width: 30,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SvgPicture.asset('assets/icons/sound.svg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    card.titleRus,
                    style: myLabelTextStyleCard,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: double.infinity,
                        child: Image.network(
                          card.photo,
                          fit: card.whiteBg == '1'
                              ? BoxFit.contain
                              : BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 40, top: 24.0, right: 40),
                  child: Text.rich(
                    TextSpan(
                      style: myExampleCard,
                      children: <InlineSpan>[
                        TextSpan(text: 'Sweet '),
                        TextSpan(
                          style: myExampleMainWordCard,
                          text: 'watermelon',
                        ),
                        TextSpan(
                          text: ' - Сладкий арбуз',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 40, top: 24.0, right: 40),
                  child: Text.rich(
                    TextSpan(
                      style: myExampleCard,
                      children: <InlineSpan>[
                        TextSpan(text: 'The '),
                        TextSpan(
                          style: myExampleMainWordCard,
                          text: 'watermelon',
                        ),
                        TextSpan(
                          text: ' is very heavy - Этот арбуз очень тяжелый',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 110),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonLearned(
                context: context,
                heroTag: card.title,
                cardId: card.id,
                listLearnedCardsIDs: listLearnedCardsIDs,
                subtopicId: subtopicId,
                learned: listLearnedCardsIDs.contains(card.id),
                mapSubtopicsProgress: mapSubtopicsProgress,
                numberOfCardsInSubtopic: numberOfCardsInSubtopic,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
