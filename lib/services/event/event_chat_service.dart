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

  void deleteEventChat(Map<String, dynamic> event) async {
    WriteBatch batch = _firestore.batch();

    // Reference to the original event document
    DocumentReference originalEventDoc =
        _firestore.collection('events').doc(event['eventID']);

    // Reference to the deleted event document
    DocumentReference deletedEventDoc =
        _firestore.collection('deletedEvents').doc(event['eventID']);

    // Get the original event document data
    DocumentSnapshot eventSnapshot = await originalEventDoc.get();
    if (eventSnapshot.exists) {
      // Create a new map with the original event data and add the deletionDate field
      Map<String, dynamic> eventData =
          eventSnapshot.data() as Map<String, dynamic>;
      eventData['deletionDate'] = DateTime.now();

      // Set the event data in the deletedEvents collection
      batch.set(deletedEventDoc, eventData);
    }
    // Get the chat subcollection documents
    QuerySnapshot chatSnapshot =
        await originalEventDoc.collection('chat').get();

    // Copy each chat document to the new chat subcollection
    for (var chatDoc in chatSnapshot.docs) {
      // Reference to the new chat document
      DocumentReference newChatDoc =
          deletedEventDoc.collection('chat').doc(chatDoc.id);
      // Add the chat document data to the new chat subcollection
      batch.set(newChatDoc, chatDoc.data());
    }
  }
}
