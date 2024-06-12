import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/eventRequest.dart';
import 'package:event/components/friendRequest.dart';
import 'package:event/components/my_app_bar.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> friendRequests = [];
  List<DocumentSnapshot<Map<String, dynamic>>> eventRequests = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      var snapshot = await _userService.getRequests(_auth.currentUser!.uid);
      var requests = snapshot.docs;

      setState(() {
        friendRequests = requests
            .where((doc) => doc.data()['type'] == 'friendRequest')
            .toList();
        eventRequests =
            requests.where((doc) => doc.data()['type'] == 'event').toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _removeFriendRequest(DocumentSnapshot<Map<String, dynamic>> doc) {
    setState(() {
      friendRequests.remove(doc);
    });
  }

  void _removeEventRequest(DocumentSnapshot<Map<String, dynamic>> doc) {
    setState(() {
      eventRequests.remove(doc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Invites",
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : friendRequests.isEmpty && eventRequests.isEmpty
                  ? const Center(child: Text('No requests found'))
                  : ListView(
                      children: [
                        if (friendRequests.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Friend Requests',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ...friendRequests.map((doc) => FriendRequest(
                              request: doc.data()!,
                              onAccept: () {
                                _removeFriendRequest(doc);
                              },
                            )),
                        if (eventRequests.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Event Requests",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ...eventRequests.map((doc) => EventRequest(
                              request: doc.data()!,
                              onAccept: () {
                                _removeEventRequest(doc);
                              },
                            )),
                      ],
                    ),
    );
  }
}
