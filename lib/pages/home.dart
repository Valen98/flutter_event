import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/event_card.dart';
import 'package:event/components/my_navigation_bar.dart';
import 'package:event/services/auth/auth_services.dart';
import 'package:event/services/event/event_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventService _eventService = EventService();
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: _builderEventList(),
      bottomNavigationBar: const MyBottomNav(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Event App',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: const Color(0xff1D1D1D),
      elevation: 0,
      centerTitle: true,
      actions: [IconButton(onPressed: signOut, icon: const Icon(Icons.logout))],
    );
  }

  Widget _builderEventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventService.getEvents(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildEventItem(document))
                .toList());
      },
    );
  }

  Widget _buildEventItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          EventCard(event: data),
        ],
      ),
    );
  }
}
