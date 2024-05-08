import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String hostID;
  final String eventName;
  final String eventDesc;
  final DateTime eventDate;
  final TimeOfDay eventHours;
  final String hostEmail;
  final Timestamp created;

  Event(
      {required this.hostID,
      required this.eventName,
      required this.eventDesc,
      required this.eventDate,
      required this.eventHours,
      required this.hostEmail,
      required this.created});

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'hostID': hostID,
      'eventName': eventName,
      'eventDesc': eventDesc,
      'eventDate': eventDate,
      'eventHours': eventHours,
      'hostEmail': hostEmail,
      'created': created,
    };
  }
}
