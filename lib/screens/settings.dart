import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthServiceFirebase auth = AuthServiceFirebase();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    if (user != null) {
      return NetworkSensitive(
        child: Scaffold(
          backgroundColor: MyColors.mainBgColor,
          appBar: AppBar(
            elevation: 0, // Removes status bar's shadow.
            backgroundColor: MyColors.mainBgColor,
            title: Text('Профиль'),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 18.0),
                child: GestureDetector(
                  onTap: () async {
                    await auth.signOut();
                    //Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Выйти',
                      style: TextStyle(
                        color: MyColors.mainBrightColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user.phoneNumber == '' || user.phoneNumber == null
                  ? buildSocialNetworkUserHeader(user)
                  : buildPhoneHeader(user),
              // buildUserMenu(context),
            ],
          ),
          bottomNavigationBar: AppBottomNav(selectedIndex: 2),
        ),
      );
    } else {
      return LoginPage(prevPage: "cardDetails");
    }
  }

  Widget buildUserMenu(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder(
        stream: DB.getUserInfoStream(user.uid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            String engVariantName;
            String access;
            snapshot.data["eng_version"] == "br"
                ? engVariantName = "Британский"
                : engVariantName = "Американский";

            snapshot.data["premium"] == false
                ? access = "Базовый"
                : access = "Премиум";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*buildSettingsMenuItem('Pre-intermediate', 'Уровень', action: () {
                  Navigator.of(context)
                  .push(_createRouteChooseLevel());
                }),*/
                /*buildSettingsMenuItem(engVariantName, 'Вариант английского',
                    action: () {
                  Navigator.of(context).push(_createRouteChooseVariant());
                }),*/
                buildSettingsMenuItem(access, 'Доступ к приложению'),
                if (snapshot.data["premium"] == false)
                  Column(
                    children: <Widget>[
                      MainButton(
                          title: 'Купить Премиум за 1490 ₽', action: () {}),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 210,
                          child: Text(
                            'Вы получите бессрочный доступ к каталогу из 2500+ карточек',
                            style: mySubtitle14Style,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          } else {
            return LinearProgressIndicator();
          }
        });
  }

  Widget buildSettingsMenuItem(String title, String subtitle,
      {Function action}) {
    return action != null
        ? InkWell(
            onTap: action,
            child: buildSettingsMenuItemRow(title, subtitle, true),
          )
        : buildSettingsMenuItemRow(title, subtitle, false);
  }

  Row buildSettingsMenuItemRow(
      String title, String subtitle, bool showArrowRight) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 27.0, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: mySubtitle14Style,
                    ),
                  ],
                ),
              ),
              if (showArrowRight == true)
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, right: 18.0),
                    child: SvgPicture.asset("assets/icons/arrow_right.svg"),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPhoneHeader(User user) => Padding(
        padding: const EdgeInsets.only(
            top: 49.0, right: 27, bottom: 34.0, left: 27.0),
        child: Container(
          child: Text(
            user.phoneNumber != null ? user.phoneNumber : '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );

  Widget buildSocialNetworkUserHeader(User user) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 34.0, right: 27, bottom: 44.0, left: 27.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (user.photoURL != null)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(user.photoURL),
                ),
              ),
            ),
          SizedBox(width: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.displayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                user.email ?? '',
                style: mySubtitle14Style,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
