import 'package:event/model/user.dart';
import 'package:event/services/profile_service/profile_service.dart';
import 'package:event/utils/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  MyUser? currentUser = CurrentUser().user;

  //final CurrentUser _currentUser = CurrentUser.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: currentUser != null
              ? Column(
                  children: [
                    Text("Welcome ${currentUser!.displayName}"),
                    Text("Email ${currentUser!.email}"),
                    Text("uid ${currentUser!.uid}"),
                  ],
                )
              : const Text("Not signed in")),
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
      //actions: [IconButton(onPressed: () {}), icon: const Icon(Icons.logout))],
    );
  }

  /*Widget _buildProfile() {
    return StreamBuilder(stream: _profileService.getProfile(''), builder: builder)
  }*/
}
