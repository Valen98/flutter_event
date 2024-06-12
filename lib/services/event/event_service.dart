import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/event.dart';
import 'package:event/model/request.dart';
import 'package:event/services/event/event_chat_service.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  //Create Event
  Future<void> createEvent(
      String eventName,
      String eventDesc,
      DateTime eventDate,
      String? color,
      String address,
      String fullAddress,
      String addressID) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Event newEvent = Event(
        hostID: currentUserID,
        eventName: eventName,
        eventDesc: eventDesc,
        eventDate: eventDate,
        hostEmail: currentUserEmail,
        hostDisplayName: await _userService.getDisplayName(currentUserID),
        created: timestamp,
        eventID: "",
        color: color,
        members: [currentUserID],
        address: address,
        fullAddress: fullAddress,
        addressID: addressID);

    DocumentReference eventRef =
        await _firestore.collection('events').add(newEvent.toMap());

    //Send in the ID of the event into event.
    await _firestore
        .collection('events')
        .doc(eventRef.id)
        .update({'eventID': eventRef.id});

    await _firestore.collection('users').doc(currentUserID).update({
      'events': FieldValue.arrayUnion([eventRef.id])
    });
  }

  /* Stream<QuerySnapshot> getEvents(String currentUserID) {
    return _firestore
        .collection('events')
        .doc('event_$currentUserID')
        .collection('event')
        .orderBy('eventDate', descending: false)
        .snapshots();
  }*/

  Stream<List<String>> getEventIDsFromUser(String currentUserID) {
    return _firestore
        .collection('users')
        .doc(currentUserID)
        .snapshots()
        .map((snapshot) {
      List<String> eventIDs = [];
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data['events'] != null) {
          // Extract array of event IDs from user document
          List<dynamic> userEvents = data['events'];
          eventIDs =
              userEvents.cast<String>().toList(); // Convert to List<String>
        }
      }
      return eventIDs;
    });
  }

  Query<Map<String, dynamic>> getEvents(String eventID) {
    return _firestore
        .collection('events')
        .where('eventID', isEqualTo: eventID)
        .orderBy('eventDate', descending: false);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEvent(String eventID) {
    return _firestore.collection('events').doc(eventID).snapshots();
  }

  void addUserToEvent(String senderID, String senderName, String recieverID,
      recieverName, String eventID, String eventName) async {
    Request newRequest = Request(
        sender: senderID,
        senderName: senderName,
        recieverID: recieverID,
        recieverName: recieverName,
        eventID: eventID,
        eventName: eventName,
        requestID: "",
        dateTime: DateTime.now(),
        type: "event");

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

    Request newRequestWithID = Request(
        sender: senderID,
        senderName: senderName,
        recieverID: recieverID,
        recieverName: recieverName,
        eventID: eventID,
        eventName: eventName,
        requestID: requestRef.id,
        dateTime: DateTime.now(),
        type: "event");

    await _firestore
        .collection('users')
        .doc(recieverID)
        .collection('recieved')
        .doc(requestRef.id)
        .set(newRequestWithID.toMap());
  }

  Future<void> acceptEventRequest(String currentUser, String eventID) async {
    await _firestore.collection('users').doc(currentUser).update({
      'events': FieldValue.arrayUnion([eventID])
    });
    await _firestore.collection('events').doc(eventID).update({
      'members': FieldValue.arrayUnion([currentUser])
    });
  }

  Future<void> removeEventRequest(
      String currentUser, friendID, String requestID) async {
    await _firestore
        .collection('users')
        .doc(currentUser)
        .collection('recieved')
        .doc(requestID)
        .delete();

    await _firestore
        .collection('users')
        .doc(friendID)
        .collection('pending')
        .doc(requestID)
        .delete();
  }

  void deleteEvent(Map<String, dynamic> event) async {
    WriteBatch batch = _firestore.batch();

    EventChatService eventChatService = EventChatService();

    eventChatService.deleteEventChat(event);
    // Iterate through the event members
    for (var userID in event['members']) {
      // Reference to the user's document
      DocumentReference userDoc = _firestore.collection('users').doc(userID);
      // Use arrayRemove to remove the event ID from the user's events array
      batch.update(userDoc, {
        'events': FieldValue.arrayRemove([event['eventID']])
      });

      // Reference to the event document
      DocumentReference eventDoc =
          _firestore.collection('events').doc(event['eventID']);

      // Delete the event document in the batch
      batch.delete(eventDoc);

      // Commit the batch
      await batch.commit();
    }
  }
}
