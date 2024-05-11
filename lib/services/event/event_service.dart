import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create Event
  Future<void> createEvent(
      String eventName, String eventDesc, DateTime eventDate) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Event newEvent = Event(
        hostID: currentUserID,
        eventName: eventName,
        eventDesc: eventDesc,
        eventDate: eventDate,
        hostEmail: currentUserEmail,
        created: timestamp,
        eventID: "");

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

    addIDsToDocuments(currentUserID);
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
    return _firestore.collection('events').where('eventID', isEqualTo: eventID);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEvent(String eventID) {
    return _firestore.collection('events').doc(eventID).snapshots();
  }

  void addIDsToDocuments(String currentUserID) async {
    // Reference to your Firestore collection
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('events')
        .doc('event_$currentUserID')
        .collection('event');

    // Retrieve all documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Iterate over each document
    querySnapshot.docs.forEach((doc) async {
      // Get the ID of the document
      String eventID = doc.id;

      // Update the document to include the ID as a field
      await collectionRef.doc(eventID).update({'eventID': eventID});
    });
  }
}
