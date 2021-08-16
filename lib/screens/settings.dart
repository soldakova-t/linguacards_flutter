import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:magicards/api/purchase_api.dart';
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
          ),
          body: _buildBody(user, context),
          bottomNavigationBar: AppBottomNav(selectedIndex: 2),
        ),
      );
    } else {
      return LoginPage();
    }
  }

  Widget _buildBody(User user, BuildContext context) {
    final double buttonSignOutWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              if (user.phoneNumber == '' || user.phoneNumber == null)
                buildSocialNetworkUserHeader(user),
              buildUserMenu(context),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: Container(
            width: buttonSignOutWidth,
            child: AdditionalButton(
              title: "Выйти",
              action: () async {
                await auth.signOut();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUserMenu(BuildContext context) {
    User user = Provider.of<User>(context);
    bool isLoading = false; // Must be somewhere else

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
                ? access = "Не оформлена"
                : access = "Действует до 01.08.2022";

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

                user.phoneNumber == '' || user.phoneNumber == null
                    ? buildSettingsMenuItem('Электронная почта', user.email)
                    : buildSettingsMenuItem('Номер телефона', user.phoneNumber),
                buildSettingsMenuItem(
                    'Подписка на полную версию приложения', access),
                if (snapshot.data["premium"] == false)
                  Column(
                    children: <Widget>[
                      MainButton(
                        title: 'Выбрать подписку',
                        action: () {
                          isLoading ? null : fetchOffers();
                        },
                      ),
                      /*Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Вы получите доступ к каталогу из 2500+ карточек',
                          style: mySubtitle14Style,
                          textAlign: TextAlign.center,
                        ),
                      ),*/
                    ],
                  ),
              ],
            );
          } else {
            return CircularProgress();
          }
        });
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Plans Found"),
        ),
      );
    } else {
      final offer = offerings.first;
      print('Offer: $offer');

      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.amber,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Modal BottomSheet'),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget buildSettingsMenuItem(String label, String value, {Function action}) {
    return action != null
        ? InkWell(
            onTap: action,
            child: buildSettingsMenuItemRow(label, value, true),
          )
        : buildSettingsMenuItemRow(label, value, false);
  }

  Row buildSettingsMenuItemRow(
      String label, String value, bool showArrowRight) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 27.0, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: mySubtitle14Style,
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
      padding: const EdgeInsets.only(right: 27.0, bottom: 27.0, left: 27.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 8),
          Text(
            user.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSignOut() {
    return ElevatedButton(
      style: mySecondaryButtonStyle,
      child: Center(child: Text("Выйти", style: mySecondaryButtonTextStyle)),
      onPressed: () async {
        await auth.signOut();
      },
    );
  }
}
