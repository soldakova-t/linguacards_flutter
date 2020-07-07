import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicards/services/authservice.dart';
import 'package:magicards/shared/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 25 + MediaQuery.of(context).padding.top),
                Container(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close),
                ),
                SizedBox(height: 29 + MediaQuery.of(context).padding.top),
                Container(
                  alignment: Alignment.topLeft,
                  height: 48,
                  child: SvgPicture.asset('assets/icons/logo_auth.svg'),
                ),
                SizedBox(height: 26),
                Text(
                  'Добро пожаловать в Magicards!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: MyColors.mainDarkColor,
                  ),
                ),
                SizedBox(height: 32),
                Container(
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
                                    ),
                                    decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.all(0.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: MyColors.inputBgColor,
                                            width: 0.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: MyColors.inputBgColor,
                                            width: 0.0),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        this.phoneNo = '+7' + val;
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
                ),
                codeSent
                    ? TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: 'Код из SMS'),
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                      )
                    : Container(),
                SizedBox(height: 8),
                Text(
                  'Мы отправим SMS, чтобы подтвердить номер телефона',
                  style: TextStyle(
                    fontSize: 12,
                    color: hexToColor('#6D6F9D'),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  height: 56,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: hexToColor('#464EFF'),
                      child: Center(
                          child: codeSent
                              ? Text(
                                  'Войти',
                                  style: myAuthButtonTextStyle,
                                )
                              : Text(
                                  'Получить код по SMS',
                                  style: myAuthButtonTextStyle,
                                )),
                      onPressed: () {
                        codeSent
                            ? AuthService()
                                .signInWithOTP(smsCode, verificationId)
                            : verifyPhone(phoneNo);
                      }),
                )
              ],
            ),
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      print('PhoneVerificationCompleted');
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('PhoneVerificationFailed' + '${authException.message}');
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
