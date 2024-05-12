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

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriendsFromID(
      String userID) async {
    return await _firestore.collection('users').doc(userID).get();
  }

  Future<int> getNrOfFriends(String userID) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(userID).get();
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && (data as Map<String, dynamic>)['friends'] != null) {
        List<dynamic>? friendsList = data['friends'];

        // Return the number of friends (length of the friendsList)
        if (friendsList != null) {
          return friendsList.length;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }
}
