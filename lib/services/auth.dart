import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/services.dart';

class AuthServiceFirebase {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  // Firebase user a realtime stream
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  // Determine if Apple Signin is available on device
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<FirebaseUser> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple
      }

      final AuthCredential credential =
          OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Sign in with Google
  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// This mehtod makes the real auth
  Future<FirebaseUser> firebaseAuthWithFacebook(
      {@required FacebookAccessToken token}) async {
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token.token);
    FirebaseUser firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    return firebaseUser;
  }

  /// Sign in with Facebook
  Future<FirebaseUser> loginFacebook() async {
    FirebaseUser user;
    try {
      final facebookLogin = new FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          user = await firebaseAuthWithFacebook(token: result.accessToken);
          print('FACEBOOK LOGGED IN');
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('FACEBOOK CANCELED BY USER');
          break;
        case FacebookLoginStatus.error:
          print('FACEBOOK ERROR');
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
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    return user;
  }

  /// Sign in with OTP (phone auth)
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signInWithCredential(authCreds);
  }

  signInWithCredential(AuthCredential authCreds) async {
    String errorMessage;
    try {
      AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(authCreds);
      String phone = authResult.user.phoneNumber;
      if (await DB.userExists(phone) == false) {
        print('USER DOESNT EXIST');
        DB.addUser(phone);
      } else {
        print('USER EXISTS');
      }
    } catch (e) {
      errorMessage = e.code;
    }
    print('errorMessage = ' + errorMessage);
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
