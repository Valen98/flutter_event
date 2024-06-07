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
  final String address;
  final String fullAddress;
  final String addressID;

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
    required this.address,
    required this.fullAddress,
    required this.addressID,
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
      'members': members,
      'address': address,
      'fullAddress': fullAddress,
      'addressID': addressID
    };
  }
}
