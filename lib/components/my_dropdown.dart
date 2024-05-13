import 'package:flutter/material.dart';

class MyDropDown extends StatelessWidget {
  final DropdownButtonHideUnderline dropdown;
  const MyDropDown({super.key, required this.dropdown});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color(0xff2E2E2E),
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        width: 185,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: dropdown,
        ));
  }
}
