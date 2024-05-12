import 'package:event/components/my_app_bar.dart';
import 'package:event/components/my_button.dart';
import 'package:event/components/my_text_field.dart';
import 'package:event/services/event/event_service.dart';
import 'package:flutter/material.dart';

class NewEventPage extends StatefulWidget {
  final VoidCallback onHomePressed;
  const NewEventPage({super.key, required this.onHomePressed});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final EventService _eventService = EventService();
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventTimeController = TextEditingController();
  late DateTime _pickedDate;
  late int _hour;
  late int _minute;

  void postEvent() async {
    if (eventNameController.text.isNotEmpty &&
        eventDescriptionController.text.isNotEmpty &&
        eventDateController.text.isNotEmpty &&
        eventTimeController.text.isNotEmpty) {
      DateTime eventDate =
          _pickedDate.add(Duration(hours: _hour, minutes: _minute));
      await _eventService.createEvent(
          eventNameController.text, eventDescriptionController.text, eventDate);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Event created with the name: ${eventNameController.text}")));
      widget.onHomePressed();
    }
  }

  void cancelEvent() {
    eventNameController.clear();
    eventDescriptionController.clear();
    eventDateController.clear();
    eventTimeController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Event cancelled")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Create a new event!'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            MyTextField(
              controller: eventNameController,
              hintText: 'Event name',
              obscureText: false,
              readOnly: false,
            ),
            const SizedBox(
              height: 25,
            ),

            //Max lines null Long text input field
            MyTextField(
              controller: eventDescriptionController,
              hintText: 'Event Description',
              obscureText: false,
              readOnly: false,
              maxLines: null,
            ),

            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                //DatePicker
                Expanded(
                  child: MyTextField(
                    controller: eventDateController,
                    hintText: 'Date',
                    obscureText: false,
                    prefixIcon: const Icon(Icons.calendar_today),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),

                //TimePicker
                Expanded(
                  child: MyTextField(
                    controller: eventTimeController,
                    hintText: 'Time',
                    obscureText: false,
                    prefixIcon: const Icon(Icons.alarm),
                    readOnly: true,
                    onTap: () {
                      _selectHours();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    child: MyButton(
                        onTap: cancelEvent,
                        bgColor: const Color(0xffC92A2A),
                        text: 'Cancel')),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: MyButton(
                      onTap: postEvent,
                      bgColor: const Color(0xff228E28),
                      text: 'Create event'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        eventDateController.text = picked.toString().split(" ")[0];
        _pickedDate = DateUtils.dateOnly(picked);
      });
    }
  }

  Future<void> _selectHours() async {
    TimeOfDay? pickedHour =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedHour != null) {
      setState(() {
        _hour = pickedHour.hour;
        _minute = pickedHour.minute;
        eventTimeController.text =
            pickedHour.format(context).toString().split(' ')[0];
      });
    }
  }
}
