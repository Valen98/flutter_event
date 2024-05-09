import 'package:event/pages/home.dart';
import 'package:event/pages/new_event.dart';
import 'package:event/pages/profile.dart';
import 'package:event/pages/search.dart';
import 'package:flutter/material.dart';

class MyBottomNav extends StatefulWidget {
  const MyBottomNav({super.key});

  @override
  State<MyBottomNav> createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<MyBottomNav> {
  final Color selectedColor = const Color(0xff533AC7);

  List<Widget> pageList = [
    const HomePage(),
    const SearchPage(),
    const NewEventPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xff1D1D1D)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 50,
              ),
              IconButton(
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewEventPage()));
                  },
                  icon: const Icon(
                    Icons.event,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 50,
              ),
              IconButton(
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
