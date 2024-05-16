import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/my_app_bar.dart';
import 'package:event/components/my_button.dart';
import 'package:event/components/my_checkbox.dart';
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
  List<dynamic> friendsID = [];
  List<dynamic> alreadyMember = [];
  bool iconVisible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, Color> colors = {
    'Purple': const Color(0xff533AC7),
    'Green': const Color(0xff3AC762),
    'Pink': const Color(0xffC73A80),
    'Yellow': const Color(0xffFAC234),
    'Red': const Color(0xffCC1A1A),
    'Orange': const Color(0xffE0831F)
  };

  @override
  void initState() {
    getFriendsID();
    super.initState();
  }

  void getFriendsID() async {
    var data = await _userService.getFriendsFromID(_auth.currentUser!.uid);

    setState(() {
      List<dynamic> friendsIDChecker = data.data()!['friends'];
      if (widget.event['members'] != null) {
        List<dynamic> alreadyMember = widget.event['members'];
        for (var user in friendsIDChecker) {
          if (!alreadyMember.contains(user)) {
            friendsID.add(user);
          }
        }
      } else {
        friendsID = friendsIDChecker;
      }
    });
  }

  void addedFriend(String userID) {
    setState(() {
      friendsID.remove(userID);
      iconVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          title: "Event ${widget.event['eventName']}",
          onPressed: () {
            _scaffoldKey.currentState!.openEndDrawer();
          },
          bgColor: widget.event['color'] != "" && widget.event['color'] != null
              ? colors[widget.event['color']]!.withOpacity(0.6)
              : const Color(0xff1D1D1D),
          icon: widget.event['hostID'] == _auth.currentUser!.uid
              ? const Icon(Icons.settings, color: Colors.white)
              : null,
        ),
        body: _eventPage(context),
        endDrawer: widget.event['hostID'] == _auth.currentUser!.uid
            ? _drawer(context)
            : null);
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff1D1D1D),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: widget.event['color'] != "" &&
                          widget.event['color'] != null
                      ? colors[widget.event['color']]!
                      : const Color(0xff1D1D1D)),
              child: const Text("Drawer Header")),
          Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add_box,
                  color: Color(0xff533AC7),
                ),
                title: const Text(
                  "Add friends to event",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: const Color(0xff303335),
                      enableDrag: true,
                      context: context,
                      builder: ((context) {
                        if (friendsID.isNotEmpty) {
                          return _friendsList();
                        } else {
                          return const Center(
                            child: Text(
                              "No more friends to add.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      }));
                },
              ),
              ListTile(
                title: const Text("Item 2"),
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: MyButton(
                  bgColor: const Color(0xffC92A2A),
                  onTap: () async {
                    _eventService.deleteEvent(widget.event);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Event: ${widget.event['eventName']} has been deleted")));
                    //Close drawer
                    Navigator.pop(context);
                    //Go back to home page
                    Navigator.pop(context);
                  },
                  text: "Delete Event",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  SafeArea _eventPage(BuildContext context) {
    return SafeArea(
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "When: ${dateFormat.format(widget.event['eventDate'].toDate())}",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.event['eventDesc'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  
              const MyCheckbox(title: "Test checkBox")
            ],
          ),
        ),
      ),
    );
  }

  //Future work: Make the friend removed from the list when the friend is added.
  Column _friendsList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: friendsID.length,
            itemBuilder: (context, index) {
              dynamic friend = friendsID[index];

              return StreamBuilder(
                  stream: _userService.getProfile(friend),
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error + ${snapshot.error.toString()}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          value: null,
                          semanticsLabel: 'Loading',
                        ),
                      );
                    }
                    DocumentSnapshot user = snapshot.data!;
                    return _friendsItem(user);
                  }));
            },
          ),
        ),
      ],
    );
  }

  ListTile _friendsItem(DocumentSnapshot user) {
    return ListTile(
        title: Text(
          user['displayName'],
          style: const TextStyle(color: Colors.white),
        ),
        trailing: iconVisible
            ? IconButton(
                onPressed: () {
                  _eventService.addUserToEvent(
                      user['uid'], widget.event['eventID']);
                  addedFriend(user['uid']);
                },
                icon: const Icon(
                  Icons.add_box,
                  color: Color(0xff533AC7),
                ),
              )
            : const Text(
                "Invited",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ));
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
