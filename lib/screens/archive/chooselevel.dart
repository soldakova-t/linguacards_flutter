/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class ChooseLevel extends StatelessWidget {
  final AuthServiceFirebase auth = AuthServiceFirebase();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    if (user != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Уровень'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectionListItem(
                title: 'Elementary',
                action: () {},
                progress: 0.5,
                checked: true,
              ),
              SelectionListItem(
                title: 'Pre-intermediate',
                action: () {},
                progress: 0.0,
                checked: false,
              ),
              SelectionListItem(
                title: 'Intermediate',
                action: () {},
                progress: 0.0,
                checked: false,
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNav(selectedIndex: 2),
      );
    } else {
      return LoginPage();
    }
  }
}*/
