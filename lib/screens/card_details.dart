import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:magicards/screens/training_flashcards.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

/*class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({
    Key key,
    this.card,
    this.listLearnedCardsIDs,
    this.subtopicId,
    this.mapSubtopicsProgress,
    this.numberOfCardsInSubtopic,
    this.buildMessageYouAreSignedIn,
    this.userInfo,
  }) : super(key: key);

  final Magicard card;
  final List<String> listLearnedCardsIDs;
  final String subtopicId;
  final Map<String, String> mapSubtopicsProgress;
  final int numberOfCardsInSubtopic;
  final bool buildMessageYouAreSignedIn;
  final Map<String, dynamic> userInfo;

  @override
  _CardDetailsScreenState createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  String _engVersion;

  @override
  void initState() {
    if (widget.userInfo != null) _engVersion = widget.userInfo["eng_version"];
    Globals.playPronounciation(widget.card.sound[_engVersion] ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    print(widget.userInfo);
    print(_engVersion);

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
                    capitalize(widget.card.title),
                    style: myH1Card,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: GestureDetector(
                    onTap: () {
                      Globals.playPronounciation(
                          widget.card.sound[_engVersion] ?? "");
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          '[' + widget.card.transcription + ']',
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
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    capitalize(widget.card.titleRus),
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
                          widget.card.photo,
                          fit: widget.card.whiteBg == '1'
                              ? BoxFit.contain
                              : BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(height: 30),
                /*Padding(
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
                ),*/
                SizedBox(height: 110),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: user != null
                  ? ButtonLearned(
                      context: context,
                      heroTag: widget.card.title,
                      cardId: widget.card.id,
                      listLearnedCardsIDs: widget.listLearnedCardsIDs,
                      subtopicId: widget.subtopicId,
                      learned:
                          widget.listLearnedCardsIDs.contains(widget.card.id),
                      mapSubtopicsProgress: widget.mapSubtopicsProgress,
                      numberOfCardsInSubtopic: widget.numberOfCardsInSubtopic,
                    )
                  : SignInBlock('signIn' + widget.card.title, "cardDetails"),
            ),
          ]),
        ),
      ),
    );
  }
}*/
