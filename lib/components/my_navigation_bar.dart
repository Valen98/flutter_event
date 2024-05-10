import 'package:flutter/material.dart';

class MyNavBar2 extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const MyNavBar2(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Create event',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ]);
  }
}
