import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/request.dart';
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

  Future<void> friendRequest(String senderID, String senderName,
      String recieverID, String recieverName, String type) async {
    //Sender
    Request newRequest = Request(
        sender: senderID,
        senderName: senderName,
        recieverID: recieverID,
        recieverName: recieverName,
        requestID: "",
        dateTime: DateTime.now(),
        type: type);

    DocumentReference requestRef = await _firestore
        .collection('users')
        .doc(senderID)
        .collection("pending")
        .add(newRequest.toMap());

    await _firestore
        .collection('users')
        .doc(senderID)
        .collection('pending')
        .doc(requestRef.id)
        .update({'requestID': requestRef.id});

    //Save into Recievers collections
    Request newRequestWithID = Request(
        sender: senderID,
        senderName: senderName,
        recieverID: recieverID,
        recieverName: recieverName,
        requestID: requestRef.id,
        dateTime: DateTime.now(),
        type: type);

    await _firestore
        .collection('users')
        .doc(recieverID)
        .collection('recieved')
        .doc(requestRef.id)
        .set(newRequestWithID.toMap());

    /*
    await _firestore.collection('users').doc(recieverID).update({
      'friends': FieldValue.arrayUnion([senderID])
    });
    */
  }

  Stream<int> getRequestNumber(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('recieved')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Future<void> acceptFriendRequest(String currentUser, String friendID) async {
    await _firestore.collection('users').doc(currentUser).update({
      'friends': FieldValue.arrayUnion([friendID])
    });

    await _firestore.collection('users').doc(friendID).update({
      'friends': FieldValue.arrayUnion([currentUser])
    });
  }

  Future<void> removeFriendRequest(
    String currentUser,
    String friendID,
    String requestID,
  ) async {
    //The user that recieves the invite is current User. Therefore delete from current user
    //Then delete from the user sending the invite inside the pending request.

    //Delete from recieved
    await _firestore
        .collection('users')
        .doc(currentUser)
        .collection('recieved')
        .doc(requestID)
        .delete();

    //Delete from pending
    await _firestore
        .collection('users')
        .doc(friendID)
        .collection('pending')
        .doc(requestID)
        .delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRequests(
      String currentUserID) {
    return _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('recieved')
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPendingRequests(
      String currentUserID) {
    return _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('pending')
        .get();
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
