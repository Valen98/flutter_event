import 'package:event/components/my_button.dart';
import 'package:event/components/my_text_field.dart';
import 'package:event/services/event/event_service.dart';
import 'package:flutter/material.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final EventService _eventService = EventService();
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventHourController = TextEditingController();
  late DateTime _pickedDate;
  late int _hour;
  late int _minute;

  void postEvent() async {
    if (eventNameController.text.isNotEmpty &&
        eventDescriptionController.text.isNotEmpty &&
        eventDateController.text.isNotEmpty &&
        eventDateController.text.isNotEmpty &&
        eventNameController.text.isNotEmpty) {
      DateTime eventDate =
          _pickedDate.add(Duration(hours: _hour, minutes: _minute));
      await _eventService.createEvent(
          eventNameController.text, eventDescriptionController.text, eventDate);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          ),
          const SizedBox(
            height: 25,
          ),

          //Max lines null Long text input field
          TextField(
            controller: eventDescriptionController,
            obscureText: false,
            maxLines: null,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Color(0xff2E2E2E),
                filled: true,
                hintText: 'Event Description',
                hintStyle: TextStyle(
                  color: Colors.grey,
                )),
          ),

          const SizedBox(
            height: 25,
          ),

          //DatePicker
          TextField(
            controller: eventDateController,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Color(0xff2E2E2E),
                filled: true,
                labelText: 'DATE',
                prefixIcon: Icon(Icons.calendar_today),
                hintStyle: TextStyle(
                  color: Colors.grey,
                )),
            readOnly: true,
            onTap: () {
              _selectDate();
            },
          ),
          const SizedBox(
            height: 25,
          ),

          //TimePicker
          TextField(
            controller: eventHourController,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Color(0xff2E2E2E),
                filled: true,
                labelText: 'Time',
                prefixIcon: Icon(Icons.punch_clock),
                hintStyle: TextStyle(
                  color: Colors.grey,
                )),
            readOnly: true,
            onTap: () {
              _selectHours();
            },
          ),

          const SizedBox(
            height: 50,
          ),

          MyButton(
              onTap: postEvent,
              bgColor: const Color(0xff228E28),
              text: 'Create event'),

          const SizedBox(
            height: 25,
          ),

          MyButton(
              onTap: () {}, bgColor: const Color(0xffC92A2A), text: 'Cancel')
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Create new Event',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: const Color(0xff1D1D1D),
      elevation: 0,
      centerTitle: true,
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
        eventHourController.text =
            pickedHour.format(context).toString().split(' ')[0];
      });
    }
  }
}
