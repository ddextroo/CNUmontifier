import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 final GoogleSignIn _googleSignIn = GoogleSignIn();

 Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
 }

 Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
 }

 Future<void>userStore(User? user) async {
    if (user != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      return users
        .doc(user.uid)
        .set({
          'fullname' : user.displayName,
          'avatar' : user.photoURL,
          'uid' : user.uid,
          'email': user.email,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        })
        .then((value) => debugPrint("Added"))
        .catchError((error) => debugPrint("Error ${error}"));
    }
 }
}