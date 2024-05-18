import 'package:event/components/my_button.dart';
import 'package:event/components/my_text_field.dart';
import 'package:event/services/event/event_task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTaskModal extends StatefulWidget {
  final String eventID;
  const MyTaskModal({super.key, required this.eventID});

  @override
  State<MyTaskModal> createState() => _MyTaskModalState();
}

class _MyTaskModalState extends State<MyTaskModal> {
  final EventTaskService _eventTaskService = EventTaskService();
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _addTextField();
  }

  void _addTextField() {
    if (_controllers.length < 5) {
      setState(() {
        _controllers.add(TextEditingController());
      });
    }
  }

  void _removeTextField(int index) {
    setState(() {
      if (_controllers.length > 1) {
        _controllers.removeAt(index);
      }
    });
  }

  Future<void> _addTasksToFirestore() async {
    List<String> taskNames =
        _controllers.map((controller) => controller.text).toList();

    await _eventTaskService.createTasks(taskNames, widget.eventID);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xff1D1D1D),
          ),
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _textFields(),
                _controllers.length < 5
                    ? InkWell(
                        onTap: _addTextField,
                        child: const Row(
                          children: [
                            Text(
                              "Add task",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.add, color: Colors.white),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 30,
                ),
                _buttons(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 150,
          child: MyButton(
            bgColor: const Color(0xffC92A2A),
            onTap: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
            text: "Cancel",
          ),
        ),
        SizedBox(
          width: 150,
          child: MyButton(
            bgColor: const Color.fromARGB(255, 51, 48, 222),
            onTap: () async {
              if (_controllers
                  .any((controller) => controller.text.isNotEmpty)) {
                await _addTasksToFirestore();
              } else {
                // Show an error message or handle the case where no valid tasks are present
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please add at least one valid task.'),
                  ),
                );
              }
              Navigator.of(context, rootNavigator: true).pop();
            },
            text: "Add tasks",
          ),
        ),
      ],
    );
  }

  Expanded _textFields() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            _controllers.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                          controller: _controllers[index],
                          hintText: "Task",
                          obscureText: false,
                          readOnly: false),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () => _removeTextField(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
