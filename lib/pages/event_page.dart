import 'package:event/components/my_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> event;
  const EventPage({super.key, required this.event});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event['eventName'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  (dateFormat.format(widget.event['eventDate'].toDate())),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.event['eventDesc'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNav(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        widget.event['eventName'],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: const Color(0xff1D1D1D),
      elevation: 0,
      centerTitle: true,
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))],
    );
  }
}
