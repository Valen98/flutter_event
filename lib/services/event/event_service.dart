import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create Event
  Future<void> createEvent(String eventName, String eventDesc,
      DateTime eventDate, String? color) async {
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
        eventID: "",
        color: color,
        members: [currentUserID]);

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

  void addUserToEvent(String userID, String eventID) async {
    await _firestore.collection('users').doc(userID).update({
      'events': FieldValue.arrayUnion([eventID])
    });
    await _firestore.collection('events').doc(eventID).update({
      'members': FieldValue.arrayUnion([userID])
    });
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

  void deleteEvent(Map<String, dynamic> event) async {
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
