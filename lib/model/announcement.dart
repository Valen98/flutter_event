import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String announcementID;
  final String eventID;
  final String userID;
  final String displayName;
  final String announcement;
  final Timestamp created;

  Announcement(
      {required this.announcementID,
      required this.eventID,
      required this.userID,
      required this.displayName,
      required this.announcement,
      required this.created});

  Map<String, dynamic> toMap() {
    return {
      'announcementID': announcementID,
      'eventID': eventID,
      'userID': userID,
      'displayName': displayName,
      'announcement': announcement,
      'created': created,
    };
  }
}
