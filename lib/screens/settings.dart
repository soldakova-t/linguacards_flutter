import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:magicards/api/purchase_api.dart';
import 'package:magicards/enums/entitlement.dart';
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
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    bool isLoading = false; // Must be somewhere else

    return StreamBuilder(
        stream: DB.getUserInfoStream(user.uid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            /*String engVariantName;
            snapshot.data["eng_version"] == "br"
                ? engVariantName = "Британский"
                : engVariantName = "Американский";*/

            String access;

            switch (entitlement) {
              case Entitlement.premium:
                access = "Оформлена";
                break;
              case Entitlement.free:
              default:
                access = "Не оформлена";
                break;
            }

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
                buildSettingsMenuItem('Премиум-подписка', access),
                if (entitlement == Entitlement.free)
                  Column(
                    children: <Widget>[
                      MainButton(
                        title: 'Выбрать премиум-подписку',
                        action: () {
                          isLoading ? null : fetchOffers();
                        },
                      ),
                      Container(
                        width: 200,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Вы получите доступ ко всем 75 темам и обновлениям',
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
            return CircularProgress();
          }
        });
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Подписки не найдены"),
        ),
      );
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      print("offerings.length = " + offerings.length.toString());
      print("packages.lenght = " + packages.length.toString());

      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Paywall(
            title: "Премиум",
            description:
                "Оформите подписку, чтобы получить доступ ко всем 75 темам и обновлениям",
            packages: packages,
            onCLickedPackage: (package) async {
              await PurchaseApi.purchasePackage(context, package);
              Navigator.pop(context);
            },
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
