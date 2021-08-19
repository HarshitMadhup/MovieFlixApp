import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future login() async {
    final user = await googleSignIn.signIn();
    final googleAuth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  getprofileImage(double radius) {
    if (firebaseAuth.currentUser!.photoURL != null) {
      return CircleAvatar(
        radius: radius,
        child: ClipOval(
            child: Image.network(
          firebaseAuth.currentUser!.photoURL!,
        )),
        backgroundColor: Colors.transparent,
      );
    } else
      Icon(Icons.account_circle, size: 100);
  }
}
