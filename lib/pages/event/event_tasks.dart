import 'package:event/components/my_task_modal.dart';
import 'package:flutter/material.dart';

class EventTasks extends StatefulWidget {
  final String eventID;
  const EventTasks({super.key, required this.eventID});

  @override
  State<EventTasks> createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
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
    return Column(
      children: [
        Row(
          children: [
            const Text("Add Task"),
            IconButton(
                onPressed: () async {
                  _openModal();
                },
                icon: const Icon(
                  Icons.add_box,
                  color: Color(0xff533AC7),
                ))
          ],
        ),
      ],
    );
  }
}
