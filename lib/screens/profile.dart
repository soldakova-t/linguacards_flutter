import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class ProfileScreen extends StatelessWidget {

  final AuthServiceFirebase auth = AuthServiceFirebase();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Профиль'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user.displayName ?? ''),
            Text(user.phoneNumber ?? ''),
            if (user.photoUrl != null)
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photoUrl),
                  ),
                ),
              ),
            Text(user.email ?? '', style: Theme.of(context).textTheme.headline),
            Spacer(),
            FlatButton(
                child: Text('Выйти'),
                color: Colors.red,
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }),
            Spacer()
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(selectedIndex: 2),
    );
    } else {
      return LoginPage();
    }
  }

}
