import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/my_checkbox.dart';
import 'package:event/components/my_task_modal.dart';
import 'package:event/services/event/event_task_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventTasks extends StatefulWidget {
  final String eventID;
  const EventTasks({super.key, required this.eventID});

  @override
  State<EventTasks> createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
  final EventTaskService _eventTaskService = EventTaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, int> modifiedTasks = {};
  Map<String, int> taskStatuses = {}; // Map to store task statuses

  Future<void> _openModal() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: MyTaskModal(
            eventID: widget.eventID,
          ),
        );
      },
    );
  }

  void _onTaskStatusChanged(String taskId, int newStatus) {
    setState(() {
      modifiedTasks[taskId] = newStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeTaskStatuses(); // Fetch initial task statuses from database
  }

  Future<void> _initializeTaskStatuses() async {
    // Fetch tasks from the database
    var snapshot = await _eventTaskService.getTasks(widget.eventID).first;
    if (snapshot.docs.isNotEmpty) {
      // Populate taskStatuses map with task statuses from the database
      setState(() {
        taskStatuses = {
          for (var doc in snapshot.docs) doc.id: doc.data()['taskStatus'] ?? 0,
        };
      });
    }
  }

  Future<void> _updateTasks() async {
    final Timestamp now = Timestamp.now();

    for (var taskId in modifiedTasks.keys) {
      final newStatus = modifiedTasks[taskId];
      await _eventTaskService.updateTask(
        widget.eventID,
        taskId,
        newStatus!,
        now,
        _auth.currentUser!.uid,
      );
    }

    // Clear modified tasks after update
    setState(() {
      modifiedTasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: _openModal,
                  child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Text("Add Task"),
                          Icon(
                            Icons.add_box,
                            color: Color(0xff533AC7),
                          )
                        ],
                      ))),
              InkWell(
                onTap: _updateTasks,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      const Text('Update task list'),
                      modifiedTasks.isNotEmpty
                          ? Badge(
                              label: Text(modifiedTasks.length.toString()),
                              child: const Icon(
                                Icons.upload,
                                color: Color(0xff533AC7),
                              ),
                            )
                          : const Icon(Icons.upload, color: Color(0xff533AC7))
                    ],
                  ),
                ),
              ),
            ],
          ),
          _tasks(),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _tasks() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _eventTaskService.getTasks(widget.eventID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "No tasks found!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        } else {
          var tasks = snapshot.data!.docs.map((doc) => doc.data()).toList();
          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 2.5,
              ),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                int taskStatus = taskStatuses[task['taskID']] ?? 0;
                String taskID = task['taskID'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCheckbox(
                      checkID: taskID,
                      title: task['taskName'],
                      //Change the checkStatus to newStatus so it updates.
                      checkStatus: taskStatus,
                      onChange: (taskID, newStatus) {
                        setState(() {
                          taskStatuses[taskID] = newStatus;
                        });
                        _onTaskStatusChanged(taskID, newStatus);
                      }),
                );
              },
            ),
          );
        }
      },
    );
  }
}
