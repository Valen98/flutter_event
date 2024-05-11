import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/my_app_bar.dart';
import 'package:event/components/my_button.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PublicProfilePage extends StatefulWidget {
  final String userID;
  const PublicProfilePage({super.key, required this.userID});

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  final UserService _profileService = UserService();
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DocumentSnapshot data;

  void addFriend(String recieverID) {
    _userService.addFriend(recieverID, _auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Profile', onPressed: () {}),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (Column(
          children: [_buildProfile()],
        )),
      ),
    );
  }

  Widget _buildProfile() {
    return StreamBuilder(
        stream: _profileService.getProfile(widget.userID),
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
                _followerNr(friends.length)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyButton(
                    onTap: () {
                      addFriend(data['uid']);
                    },
                    bgColor: Colors.blue,
                    text: 'Add Friend'),
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
