import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';

class CardsPage extends StatefulWidget {
  final Subtopic subtopic;

  CardsPage({this.subtopic});

  @override
  _CardsPageState createState() {
    return _CardsPageState();
  }
}

class _CardsPageState extends State<CardsPage> {
  List<Magicard> listOfCards = List<Magicard>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexToColor('#F3F3F3'),
        iconTheme: IconThemeData(
          color: Color(0xFF0D1333),
        ),
        title: Text(
          widget.subtopic.title,
          style: myH1,
        ),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => TrainingMatch(
                listOfCards: listOfCards,
              ),
            ),
          );
        },
        child: Icon(Icons.fitness_center),
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 0,
        isHomePage: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('cards')
          .where('subtopic', isEqualTo: widget.subtopic.title)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final card = Magicard.fromSnapshot(data);
    listOfCards.add(card);

    return Padding(
      key: ValueKey(card.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: ListTile(
        leading: Container(
          height: 70,
          child: Image.network(
            card.photo,
          ),
        ),
        title: Text(
          card.title,
          style: mySubtitle16Style,
        ),
        subtitle: Text(
          card.titleRus,
          style: mySubtitle14Style,
        ),
        trailing: SizedBox(
          width: 88,
          height: 25,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.check,
                size: 18,
                color: Colors.green[600],
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Изучено',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
