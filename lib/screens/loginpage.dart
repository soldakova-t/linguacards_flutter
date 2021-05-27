import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicards/screens/settings.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  final String prevPage;

  const LoginPage({Key key, this.prevPage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool phoneEntered = false;
  bool codeSent = false;
  bool incorrectPhoneFireBase = false;
  AuthServiceFirebase auth = AuthServiceFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                SizedBox(height: 25 + MediaQuery.of(context).padding.top),
                _buildCloseButton(context),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 17 + MediaQuery.of(context).padding.top),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        height: 58,
                        child: SvgPicture.asset('assets/icons/logo_auth.svg'),
                      ),
                      SizedBox(height: 26),
                      Text(
                        'Добро пожаловать в Lingvicards!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: MyColors.mainDarkColor,
                        ),
                      ),
                      SizedBox(height: 32),
                      codeSent ? Container() : _buildPhoneInput(),
                      codeSent ? _buildCodeInput() : Container(),
                      SizedBox(height: 8),
                      codeSent
                          ? Container(
                              height: 15,
                            )
                          : Text(
                              incorrectPhoneFireBase
                                  ? 'Некорректный номер телефона'
                                  : 'Мы отправим SMS, чтобы подтвердить номер телефона',
                              style: TextStyle(
                                fontSize: 12,
                                color: incorrectPhoneFireBase
                                    ? MyColors.mainBrightColor
                                    : hexToColor('#6D6F9D'),
                              ),
                            ),
                      SizedBox(height: 24),
                      _buildPhoneAuthButton(),
                      SizedBox(height: 28),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'или',
                              style: TextStyle(
                                fontSize: 12,
                                color: MyColors.subtitleColor,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 22),
                      _buildSocialAuthButton(
                        'Google',
                        auth.googleSignIn,
                        "assets/icons/google_logo.svg",
                        context,
                      ),
                      SizedBox(height: 4),
                      _buildSocialAuthButton(
                        'Facebook',
                        auth.loginFacebook,
                        "assets/icons/facebook_logo.svg",
                        context,
                      ),
                      SizedBox(height: 4),
                      FutureBuilder<Object>(
                        future: auth.appleSignInAvailable,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return _buildSocialAuthButton(
                              'Apple',
                              auth.appleSignIn,
                              "assets/icons/apple_logo.svg",
                              context,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  InkWell _buildSocialAuthButton(String socialName, Function loginMethod,
      String iconPath, BuildContext context) {
    return InkWell(
      onTap: () async {
        var user = await loginMethod();
        if (user != null) {
          switch (widget.prevPage) {
            case "bottomNav":
              //Navigator.of(context).push(_createProfileRoute());
              break;
            case "training":
              Navigator.of(context).pop();
              break;
            case "cardDetails":
              Navigator.of(context).pop();
              break;
            default:
              print("widget.nextPage default");
            //Navigator.of(context).push(_createProfileRoute());
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: MyColors.mainBgColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(iconPath),
            SizedBox(width: 8),
            Text.rich(
              TextSpan(
                style: myExampleCard,
                children: <InlineSpan>[
                  TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        //color: hexToColor('#6D6F9D'),
                        color: MyColors.mainDarkColor,
                      ),
                      text: 'Продолжить через '),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      //color: hexToColor('#6D6F9D'),
                      color: MyColors.mainDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                    text: socialName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildPhoneAuthButton() {
    return Container(
      height: convertHeightFrom360(context, 360, 56),
      child: ElevatedButton(
        style: myPrimaryButtonStyle,
        child: Center(
            child: codeSent
                ? Text(
                    'Войти',
                    style: myPrimaryButtonTextStyle,
                  )
                : Text(
                    'Получить код по SMS',
                    style: myPrimaryButtonTextStyle,
                  )),
        onPressed: phoneEntered == false
            ? null
            : () {
                codeSent
                    ? AuthServiceFirebase().signInWithOTP(
                        smsCode, verificationId,
                        nextPage: widget.prevPage, context: context)
                    : verifyPhone(phoneNo);
              },
      ),
    );
  }

  Container _buildCodeInput() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: MyColors.inputBgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          top: 5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Код из SMS',
              style: TextStyle(
                color: hexToColor('#6D6F9D'),
                fontSize: 12,
              ),
            ),
            Container(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: TextFormField(
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.inputBgColor, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.inputBgColor, width: 0.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildPhoneInput() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: incorrectPhoneFireBase
            ? MyColors.inputErrorColor
            : MyColors.inputBgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: incorrectPhoneFireBase
              ? MyColors.mainBrightColor
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          top: 5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Номер телефона',
              style: TextStyle(
                color: hexToColor('#6D6F9D'),
                fontSize: 12,
              ),
            ),
            Container(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.5),
                    child: Text(
                      '+7',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.inputBgColor, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.inputBgColor, width: 0.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (val) {
                          setState(() {
                            incorrectPhoneFireBase = false;
                            val.length > 9
                                ? phoneEntered = true
                                : phoneEntered = false;
                            if (val.length == 10) {
                              this.phoneNo = '+7' + val;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 13.0),
      child: Container(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.close),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      print('PhoneVerificationCompleted ');
      AuthServiceFirebase().signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      setState(() {
        incorrectPhoneFireBase = true;
      });
      print('PhoneVerificationFailed ' + '${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

Route _createProfileRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SettingsScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
