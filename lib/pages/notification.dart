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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Invites",
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //Change getPendingRequest to getRequests
        future: _userService.getPendingRequests(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests found'));
          } else {
            var requests = snapshot.data!.docs;
            var friendRequests = requests
                .where((doc) => doc.data()['type'] == 'friendRequest')
                .toList();
            var eventRequests =
                requests.where((doc) => doc.data()['type'] == 'event').toList();
            return ListView(
              children: [
                if (friendRequests.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Friend Requests',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ),
                ...friendRequests
                    .map((doc) => FriendRequest(request: doc.data())),
                if (eventRequests.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Event Requests",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ),
                ...eventRequests.map((doc) => EventRequest(request: doc.data()))
              ],
            );
          }
        },
      ),
    );
  }
}
