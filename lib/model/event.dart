import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String hostID;
  final String eventName;
  final String eventDesc;
  final DateTime eventDate;
  final String hostDisplayName;
  final String hostEmail;
  final Timestamp created;
  final String eventID;
  final String? color;
  final List members;

  Event({
    required this.hostID,
    required this.eventName,
    required this.eventDesc,
    required this.eventDate,
    required this.hostDisplayName,
    required this.hostEmail,
    required this.created,
    required this.eventID,
    required this.members,
    this.color,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'hostID': hostID,
      'eventName': eventName,
      'eventDesc': eventDesc,
      'eventDate': eventDate,
      'hostDisplayName': hostDisplayName,
      'hostEmail': hostEmail,
      'created': created,
      'eventID': eventID,
      'color': color,
      'members': members
    };
  }
}
