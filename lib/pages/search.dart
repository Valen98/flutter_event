import 'package:event/components/my_app_bar.dart';
import 'package:event/components/my_text_field.dart';
import 'package:event/pages/public_profile.dart';
import 'package:event/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchUserController = TextEditingController();
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List _allUsers = [];
  List _resultList = [];
  bool iconVisible = true;

  @override
  void initState() {
    getAllUserStream();
    _searchUserController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    if (_searchUserController.text != "") {
      for (var clientSnapshot in _allUsers) {
        String name = clientSnapshot['displayName'].toString().toLowerCase();
        if (name.contains(_searchUserController.text.toLowerCase())) {
          showResult.add(clientSnapshot);
        }
      }
    } else {
      showResult = [];
    }

    setState(() {
      _resultList = showResult;
    });
  }

  getAllUserStream() async {
    var data = await _userService.getAllUsers();

    setState(() {
      _allUsers = data.docs;
    });

    searchResultList();
  }

  @override
  void dispose() {
    _searchUserController.removeListener(_onSearchChanged);
    _searchUserController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getAllUserStream();
    super.didChangeDependencies();
  }

  void addFriend(String recieverID) {
    _userService.friendRequest(
        recieverID, _auth.currentUser!.uid, "friendRequest");
    setState(() {
      iconVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Search for friends'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextField(
                controller: _searchUserController,
                hintText: 'Search for user',
                obscureText: false,
                readOnly: false),
            Expanded(
              child: ListView.builder(
                  itemCount: _resultList.length,
                  itemBuilder: ((context, index) {
                    dynamic user = _resultList[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PublicProfilePage(
                                        userID: user['uid'])));
                          },
                          child: ListTile(
                            title: Text(
                              user['displayName'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: iconVisible
                                ? IconButton(
                                    onPressed: () {
                                      addFriend(user[
                                          'uid']); // Perform action when icon is pressed
                                    },
                                    icon: const Icon(
                                      Icons.add_box,
                                      color: Color(0xff533AC7),
                                    ),
                                  )
                                : const Text(
                                    "Friend Request Sent",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                          ),
                        ),
                      ],
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
