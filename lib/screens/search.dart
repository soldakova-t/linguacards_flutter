import 'package:flutter/material.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Поиск"),
      ),
      body: Column(
        //mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: TextField(
              onChanged: (val) => initiateSearch(val),
              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                hintText: 'Английское или русское слово',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                icon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (name != "" && name != null)
                  ? Firestore.instance
                      .collection("cards")
                      .where("nameSearch", arrayContains: name)
                      .snapshots()
                  : Firestore.instance.collection("cards").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return ListView(
                      children:
                          snapshot.data.documents.map((DocumentSnapshot card) {
                        return ListTile(
                          title: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 20.0, bottom: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    card["photo"],
                                    height: 40,
                                    width: 40,
                                    fit: card["whiteBg"] == '1'
                                        ? BoxFit.contain
                                        : BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(capitalize(card['title'])),
                                  Text(capitalize(card['titleRus'])),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 1,
        isHomePage: false,
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }
}