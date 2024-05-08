import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create Event
  Future<void> createEvent(String eventName, String eventDesc,
      DateTime eventDate, TimeOfDay eventHours) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Event newEvent = Event(
        hostID: currentUserID,
        eventName: eventName,
        eventDesc: eventDesc,
        eventDate: eventDate,
        eventHours: eventHours,
        hostEmail: currentUserEmail,
        created: timestamp);

    await _firestore
        .collection('events')
        .doc('event_$currentUserID')
        .collection('event')
        .add(newEvent.toMap());
  }

  Stream<QuerySnapshot> getEvents(String currentUserID) {
    return _firestore
        .collection('events')
        .doc('event_$currentUserID')
        .collection('event')
        .orderBy('eventDate', descending: false)
        .snapshots();
  }
}
