import 'package:event/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send message
  Future<void> sendMessage(
      String hostID, String eventID, String message) async {
    //get current user info
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        eventID: eventID,
        message: message,
        timestamp: timestamp);

    // add new message to database
    await _firestore
        .collection('events')
        .doc(eventID)
        .collection('chat')
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessage(String hostID, String eventID) {
    return _firestore
        .collection('events')
        .doc(eventID)
        .collection('chat')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
