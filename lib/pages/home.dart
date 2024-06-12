import 'package:event/components/event_card.dart';
import 'package:event/components/my_app_bar.dart';
import 'package:event/components/my_navigation_bar.dart';
import 'package:event/pages/event/new_event.dart';
import 'package:event/pages/notification.dart';
import 'package:event/pages/profile.dart';
import 'package:event/pages/search.dart';
import 'package:event/services/event/event_service.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventService _eventService = EventService();
  final UserService _userService = UserService();
  String numberOfRequests = "";

  void addEvent() {
    _onItemTapped(2);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    numberOfRequests =
        _userService.getRequestNumber(_auth.currentUser!.uid).toString();
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
        //onHomePressed is so that when an event is created, it returns back to home page
        return NewEventPage(onHomePressed: () {
          _onItemTapped(0);
        });
      case 3:
        return const ProfilePage();
      default:
        return Container();
    }
  }

  Widget home() {
    return Scaffold(
      appBar: MyAppBar(
        title: "Event App",
        badge: StreamBuilder<int>(
          stream: _userService.getRequestNumber(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for data from the stream, display a default badge with no label
              return const Badge(
                child: Icon(Icons.notifications_outlined),
              );
            } else if (snapshot.hasError) {
              // If there's an error with the stream, display a badge with no label
              return const Badge(
                child: Icon(Icons.notifications_outlined),
              );
            } else {
              // Display the badge with the number of requests from the stream
              if (snapshot.data! > 0) {
                return Badge(
                  label: Text(snapshot.data.toString()),
                  offset: const Offset(-7, 7),
                  child: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationPage(),
                      ),
                    ),
                    icon: const Icon(Icons.notifications),
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  ),
                  icon: const Icon(Icons.notifications_outlined),
                );
              }
            }
          },
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
            if (eventIDs.isNotEmpty) {
              return ListView.builder(
                itemCount: eventIDs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                      stream: _eventService.getEvent(eventIDs[index]),
                      builder: (contextx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
            } else {
              return const Center(
                child: Text(
                  "No events found!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            }
          }
        });
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
