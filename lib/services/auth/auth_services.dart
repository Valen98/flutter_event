import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/user.dart';
import 'package:event/utils/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of Firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Sign in user
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      MyUser currentUser = MyUser(
          displayName: await getDisplayName(uid),
          email: email,
          uid: userCredential.user!.uid);
      CurrentUser().setUser(currentUser);

      _fireStore
          .collection('users')
          .doc(uid)
          .set({'uid': uid, 'email': email}, SetOptions(merge: true));

      return userCredential;
    }
    //Catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password, displayName) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // after creating the user, create a new document for the user in the users collection
      MyUser currentUser = MyUser(
          displayName: displayName,
          email: email,
          uid: userCredential.user!.uid);
      CurrentUser().setUser(currentUser);

      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'displayName': displayName
      });

      // Create a public user table to find users
      _fireStore.collection('publicUser').doc(displayName).set({
        'displayName': displayName,
        'uid': userCredential.user!.uid,
        'email': email
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String> getDisplayName(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _fireStore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc.get('displayName');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
    return "";
  }

  //Sign out user
  Future<void> signOut() async {
    CurrentUser().clearUser();
    return await FirebaseAuth.instance.signOut();
  }
}
