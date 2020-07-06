import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_dress/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

abstract class AuthService {
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInUserWithEmailAndPassword(String email, String password);
  Stream<User> get onAuthStateChanged;
  Future<FirebaseUser> checkUserAuthenticated();
  Future<void> logout();
}

class Auth implements AuthService {
  final _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<FirebaseUser> checkUserAuthenticated() async {
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser != null ? currentUser : null;
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final reference =
          Firestore.instance.document('users/${authResult.user.uid}');
      Map<String, dynamic> data =
          User(uid: '${authResult.user.uid}', email: email).toMap();
      await reference.setData(data);
      FirebaseUser user = authResult.user;
      return _userFromFirebase(user);
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        throw PlatformException(
            code: 'Weak Password',
            details: 'Password length should be atleas 6 characters');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        throw PlatformException(
            code: 'Invalid Email',
            details: 'The email address is badly formatted.');
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        throw PlatformException(
            code: 'Email Already exists', details: 'Login into the app');
      } else {
        throw PlatformException(
            code: 'Some error occured',
            details: 'Try again later or check your internet connection');
      }
    }
  }

  Future<User> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return _userFromFirebase(user);
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        throw PlatformException(
            code: 'Weak Password',
            details: 'Password length should be atleast 6 characters');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        throw PlatformException(
            code: 'Invalid Email',
            details: 'The email address is badly formatted');
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        throw PlatformException(
            code: 'User not Found',
            details:
                'There is no user record corresponding to this credentials, create an account');
      } else {
        throw PlatformException(
            code: 'Some error occured',
            details: 'Try again later or check your internet connection');
      }
    }
  }

  // Future<User> signInWithGoogle(String username) async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleAccount = await googleSignIn.signIn();
  //   if (googleAccount != null) {
  //     final googleAuth = await googleAccount.authentication;
  //     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //       final authResult = await _auth.signInWithCredential(
  //           GoogleAuthProvider.getCredential(
  //               idToken: googleAuth.idToken,
  //               accessToken: googleAuth.accessToken));
  //       final reference =
  //           Firestore.instance.document('users/${authResult.user.uid}');
  //       Map<String, dynamic> data = User(
  //               uid: '${authResult.user.uid}',
  //               email: '${authResult.user.email}',
  //               username: '${authResult.user.email.split('@')[0]}')
  //           .toMap();
  //       await reference.setData(data);
  //       return _userFromFirebase(authResult.user);
  //     } else {
  //       throw PlatformException(
  //         code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //         details: 'Missing google auth token',
  //       );
  //     }
  //   } else {
  //     throw PlatformException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       details: 'Sign In Aborted By User',
  //     );
  //   }
  // }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
