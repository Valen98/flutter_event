import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onPressed;
  final String title;
  final Icon? icon;
  final Color? bgColor;
  
  const MyAppBar(
      {super.key,
      this.onPressed,
      required this.title,
      this.icon,
      this.bgColor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (icon != null) {
      actions.add(
        IconButton(
          onPressed: onPressed,
          icon: icon!,
        ),
      );
    }
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      actions: actions,
    );
  }
}
