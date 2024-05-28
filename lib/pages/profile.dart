import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/event_card.dart';
import 'package:event/components/my_app_bar.dart';
import 'package:event/services/auth/auth_services.dart';
import 'package:event/services/event/event_service.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _profileService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventService _eventService = EventService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DocumentSnapshot data;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
          title: 'Profile',
          onPressed: () {
            _scaffoldKey.currentState!.openEndDrawer();
          },
          icon: const Icon(Icons.settings)),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: (Column(
          children: [_buildProfile()],
        )),
      ),
      endDrawer: _drawer(context),
    );
  }

  Widget _buildProfile() {
    return StreamBuilder(
        stream: _profileService.getProfile(_auth.currentUser!.uid),
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
          data = snapshot.data!;
          return profile();
        }));
  }

  Widget profile() {
    List<dynamic> friends = data['friends'];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                const SizedBox(height: 10),
                Text(
                  data['displayName'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 80),
                _eventNr(),
                const SizedBox(
                  width: 40,
                ),
                _followerNr(friends.length)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce at ex ac ligula interdum consequat nec a felis. Duis pulvinar tellus non rhoncus aliquet.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                myEvents(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _followerNr(int friends) {
    return Column(
      children: [
        Text(
          friends.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const Text(
          'Friends',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Column myEvents() {
    return Column(
      children: [
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'My Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.black,
          thickness: 1,
        ),
        SizedBox(
          height: 425,
          child: _builderEventList(),
        )
      ],
    );
  }

  Column _eventNr() {
    final eventsList = data['events'] as List<dynamic>;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          eventsList.length.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const Text(
          'Events',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final eventDocument = snapshot.data?.data();
                        // Check if eventDocument is not null before accessing its fields
                        if (eventDocument != null) {
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
                        } else {
                          return const SizedBox(
                            height: 1,
                            width: 1,
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
      },
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff1D1D1D),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff1D1D1D)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Profile Settings"),
                  IconButton(
                    onPressed: () => signOut(),
                    icon: const Icon(
                      color: Colors.white,
                      Icons.logout,
                    ),
                  ),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Color(0xff533AC7),
                    ),
                    title: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add_box,
                      color: Color(0xff533AC7),
                    ),
                    title: const Text(
                      "Placeholder",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          EventCard(event: data),
        ],
      ),
    );
  } */
}
