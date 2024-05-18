import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventTaskService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create tasks
  Future<void> createTasks(List<String> taskNames, String eventID) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    taskNames = taskNames
        .where((taskName) => taskName.isNotEmpty)
        .toList(); // Filter out empty task names

    if (taskNames.isNotEmpty) {
      for (String taskName in taskNames) {
        Task newTask = Task(
            taskID: "",
            eventID: eventID,
            userID: currentUserID,
            taskName: taskName,
            taskStatus: 0,
            created: timestamp,
            updated: null);

        DocumentReference taskRef = await _firestore
            .collection('events')
            .doc(eventID)
            .collection('tasks')
            .add(newTask.toMap());

        await _firestore
            .collection('events')
            .doc(eventID)
            .collection('tasks')
            .doc(taskRef.id)
            .update({'taskID': taskRef.id});
      }
    }
  }
}
