import 'package:event/components/event_card.dart';
import 'package:event/components/my_app_bar.dart';
import 'package:event/components/my_navigation_bar.dart';
import 'package:event/pages/new_event.dart';
import 'package:event/pages/profile.dart';
import 'package:event/pages/search.dart';
import 'package:event/services/auth/auth_services.dart';
import 'package:event/services/event/event_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: MyNavBar2(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return home();
      case 1:
        return const SearchPage();
      case 2:
        return const NewEventPage();
      case 3:
        return const ProfilePage();
      default:
        return Container();
    }
  }

  Widget home() {
    return Scaffold(
      appBar: MyAppBar(
        onPressed: signOut,
        title: "Event App",
        icon: const Icon(
          Icons.logout,
        ),
      ),
      body: _builderEventList(),
    );
  }

  Widget _builderEventList() {
    return StreamBuilder<List<String>>(
      stream: _eventService.getEventIDsFromUser(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> eventIDs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: eventIDs.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: _eventService.getEvent(eventIDs[index]),
                  builder: (contextx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final eventDocument = snapshot.data?.data();
                      // Check if eventDocument is not null before accessing its fields
                      if (eventDocument == null) {
                        return const Text("This should not exist");
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              EventCard(event: eventDocument),
                            ],
                          ),
                        );
                      }
                    }
                  });
            },
          );
        }
      },
    );
  }

  /* Widget _builderEventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventService.getEvents(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              value: null,
              semanticsLabel: 'Loading',
            ),
          );
        }

        return ListView(
            children: snapshot.data!.docs
                .map((document) =>
                    _buildEventItem(document.data() as Map<String, dynamic>))
                .toList());
      },
    );
  }

  Widget _buildEventItem(Map<String, dynamic> data) {
    //Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
  }*/
}
