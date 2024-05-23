import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
  
  Future<String> getDisplayName(String uid) async {
    try {
      // Fetch the document snapshot
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        // Check if the 'displayName' field exists in the data
        if (data != null && data.containsKey('displayName')) {
          return data['displayName'];
        } else {
          throw Exception("User document does not contain 'displayName'");
        }
      } else {
        throw Exception("User document does not exist");
      }
    } catch (e) {
      print("Error fetching displayName: $e");
      // Handle the error (you could return an empty string, null, or rethrow the error)
      return Future.error("Error fetching displayName: $e");
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUsersFriendsIDs(
      String uid) async {
    return await _firestore.collection('users').doc(uid).get();
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
