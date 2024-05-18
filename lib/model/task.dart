import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String taskID;
  final String eventID;
  final String userID;
  final String taskName;
  final int taskStatus;
  final Timestamp created;
  final Timestamp? updated;
  final String? updatedBy;

  Task({
    required this.taskID,
    required this.eventID,
    required this.userID,
    required this.taskName,
    required this.taskStatus,
    required this.created,
    this.updatedBy,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskID': taskID,
      'eventID': eventID,
      'userID': userID,
      'taskName': taskName,
      'taskStatus': taskStatus,
      'created': created,
      'updatedBy': updatedBy,
      'updated': updated
    };
  }
}
