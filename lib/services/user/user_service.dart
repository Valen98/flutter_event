import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firestore.collection('users').get();
  }

  Future<void> addFriend(String recieverID, String senderID) async {
    await _firestore.collection('users').doc(recieverID).update({
      'friends': FieldValue.arrayUnion([senderID])
    });

    await _firestore.collection('users').doc(senderID).update({
      'friends': FieldValue.arrayUnion([recieverID])
    });
  }
}
