import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:magicards/shared/shared.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/services.dart';
import 'package:magicards/screens/screens.dart';

class AuthServiceFirebase {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Firebase user one-time fetch
  User get getUser => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<User> get user => _auth.authStateChanges();

  // Determine if Apple Signin is available on device
  //Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  /*Future<User> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple
      }

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      UserCredential firebaseResult =
          await _auth.signInWithCredential(credential);
      User user = firebaseResult.user;

      Fluttertoast.showToast(
          msg: "Вы успешно авторизовались",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);

      await Purchases.logIn(user.uid);

      return user;
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Авторизоваться не удалось",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);

      print(error);
      return null;
    }
  }*/

  /// Sign in with Google
  Future<User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      User user;
      if (result != null) {
        // Not sure we need to check this
        user = result.user;
      }

      if (user != null) {
        if (await DB.userExists(user.uid) == false) {
          DB.addNewUser(user.uid);
        }
        Fluttertoast.showToast(
            msg: "Вы успешно авторизовались",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        await Purchases.logIn(user.uid);

        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: "Авторизоваться не удалось",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      print('Failed with error code: ${e.code}');
      print(e.message);

      return null;
    }
  }

  /*Future<User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);


      User user = result.user;

      if (await DB.userExists(user.uid) == false) {
        DB.addNewUser(user.uid);
      }

      Fluttertoast.showToast(
          msg: "Вы успешно авторизовались",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);

      return user;
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Авторизоваться не удалось",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);

      return null;
    }
  }*/

  /// This mehtod makes the real auth
  Future<User> firebaseAuthWithFacebook(
      {@required FacebookAccessToken token}) async {
    AuthCredential credential = FacebookAuthProvider.credential(token.token);
    User user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  /// Sign in with Facebook
  Future<User> loginFacebook() async {
    User user;
    try {
      final facebookLogin = new FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          user = await firebaseAuthWithFacebook(token: result.accessToken);

          if (await DB.userExists(user.uid) == false) {
            DB.addNewUser(user.uid);
          }

          Fluttertoast.showToast(
              msg: "Вы успешно авторизовались",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);

          await Purchases.logIn(user.uid);

          break;
        case FacebookLoginStatus.cancelledByUser:
          Fluttertoast.showToast(
              msg: "Вы отменили авторизацию",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);

          break;
        case FacebookLoginStatus.error:
          Fluttertoast.showToast(
              msg: "Авторизоваться не удалось",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);

          print(result.errorMessage);
          break;
      }
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Anonymous Firebase login
  Future<User> anonLogin() async {
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user;
    return user;
  }

  /// Sign in with OTP (phone auth)
  signInWithOTP(smsCode, verId, {String prevScreen, BuildContext context}) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signInWithCredential(authCreds, prevScreen: prevScreen, context: context);
  }

  signInWithCredential(AuthCredential authCreds,
      {String prevScreen, BuildContext context}) async {
    try {
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(authCreds);
      // String phone = authResult.user.phoneNumber;

      if (authResult.user != null) {
        if (await DB.userExists(authResult.user.uid) == false) {
          DB.addNewUser(authResult.user.uid);
        }

        Fluttertoast.showToast(
            msg: "Вы успешно авторизовались",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        await Purchases.logIn(authResult.user.uid);

        switch (prevScreen) {
          case "bottomNav":
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/settings');
            break;
          case "paywall":
            Navigator.of(context).pop();
            fetchOffers(context, authResult.user);
            break;
          case "cardDetails":
            Navigator.of(context).pop();
            break;
          case "settings":
            break;
          default:
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Авторизоваться не удалось",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);

      print('Failed with error: ' + e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Purchases.logOut();
    return _auth.signOut();
  }
}
