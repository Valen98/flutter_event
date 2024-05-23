import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/announcement.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventAnnouncementService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<void> createAnnouncement(String inputText, String eventID) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    String displayName = await _userService.getDisplayName(currentUserID);
    Announcement newAnnouncement = Announcement(
        announcementID: "",
        eventID: eventID,
        userID: currentUserID,
        displayName: displayName,
        announcement: inputText,
        created: timestamp);

    DocumentReference announcementRef = await _firestore
        .collection('events')
        .doc(eventID)
        .collection('announcements')
        .add(newAnnouncement.toMap());

    await _firestore
        .collection('events')
        .doc(eventID)
        .collection('announcements')
        .doc(announcementRef.id)
        .update({'announcementID': announcementRef.id});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAnnouncements(
    String eventID,
  ) {
    return _firestore
        .collection('events')
        .doc(eventID)
        .collection('announcements')
        .orderBy('created', descending: true)
        .snapshots();
  }
}
