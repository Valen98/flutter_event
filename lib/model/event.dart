import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String hostID;
  final String eventName;
  final String eventDesc;
  final DateTime eventDate;
  final String hostEmail;
  final Timestamp created;
  final String eventID;
  final String? color;

  Event(
      {required this.hostID,
      required this.eventName,
      required this.eventDesc,
      required this.eventDate,
      required this.hostEmail,
      required this.created,
      required this.eventID,
      this.color});

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'hostID': hostID,
      'eventName': eventName,
      'eventDesc': eventDesc,
      'eventDate': eventDate,
      'hostEmail': hostEmail,
      'created': created,
      'eventID': eventID,
      'color': color,
    };
  }
}
