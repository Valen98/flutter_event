import 'package:event/components/my_button.dart';
import 'package:event/pages/event_chat.dart';
import 'package:event/services/event/event_service.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventService _eventService = EventService();
  final UserService _userService = UserService();
  int _getNrOfFriends = 0;

  @override
  void initState() {
    getNrOfFriends();
    super.initState();
  }

  getNrOfFriends() async {
    int getNrOfFriends =
        await _userService.getNrOfFriends(_auth.currentUser!.uid);

    setState(() {
      _getNrOfFriends = getNrOfFriends;
    });
  }

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
                  "When: ${dateFormat.format(widget.event['eventDate'].toDate())}",
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
                ),
                MyButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventChatPage(
                                  hostID: widget.event['hostID'],
                                  eventID: widget.event['eventID'])));
                    },
                    bgColor: Colors.blue,
                    text: 'Chat'),
                MyButton(
                    onTap: () {
                      _eventService.addUserToEvent(
                          'Ly83iyupZdgiybe8lgYDPaHSz3b2',
                          widget.event['eventID']);
                    },
                    bgColor: Colors.green,
                    text: 'Invite person'),

                    ListView.builder(itemCount:  _getNrOfFriends, itemBuilder: (context, index) {
                        
                    },)
              ],
            ),
          ),
        ),
      ),
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

  // Make it possible to invite people.
}
