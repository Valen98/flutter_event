import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //Change getPendingRequest to getRequestsx
        future: _userService.getPendingRequests(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests found'));
          } else {
            var requests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var request = requests[index].data();
                // You can build your request item widget here using the 'request' data
                return ListTile(
                  title: Text(request['sender'] ?? 'No Title'),
                  subtitle: Text(request['subtitle'] ?? 'No Subtitle'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
