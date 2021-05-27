import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key key, this.orientation}) : super(key: key);

  final String orientation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // For making BottomNavigationBar transparent.
      backgroundColor: MyColors.mainBgColor,
      body: _buildBody(context),
      appBar: AppBar(
        elevation: 0, // Removes status bar's shadow.
        backgroundColor: MyColors.mainBgColor,
        title: Text('Категории'),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: 1,
        isHomePage: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          Firestore.instance.collection('topics').orderBy('order').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Category> categories = [];

          // Filling List<Category> categories.
          for (var i = 0; i < snapshot.data.documents.length; i++) {
            DocumentSnapshot categorySnapshot = snapshot.data.documents[i];
            Category category = Category.fromSnapshot(categorySnapshot);
            categories.add(category);
          }
          return CategoriesList(categories: categories);
        }
      },
    );
  }
}
