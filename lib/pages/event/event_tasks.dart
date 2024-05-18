import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/my_checkbox.dart';
import 'package:event/components/my_task_modal.dart';
import 'package:event/services/event/event_task_service.dart';
import 'package:flutter/material.dart';

class EventTasks extends StatefulWidget {
  final String eventID;
  const EventTasks({super.key, required this.eventID});

  @override
  State<EventTasks> createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
  final EventTaskService _eventTaskService = EventTaskService();
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
                  child: const Row(
                    children: [
                      Text("Add Task"),
                      Icon(
                        Icons.add_box,
                        color: Color(0xff533AC7),
                      )
                    ],
                  )),
              InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Text('Update task list'),
                    Icon(Icons.upload, color: Color(0xff533AC7)),
                  ],
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
          return const Text('No tasks found');
        } else {
          // Data is available, build the grid

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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCheckbox(
                    title: tasks[index]['taskName']!,
                    checkStatus: tasks[index]['taskStatus']!,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
