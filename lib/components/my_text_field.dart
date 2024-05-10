import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int? maxLines;
  final Function()? onTap;
  final Icon? prefixIcon;
  final bool readOnly;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.readOnly,
    this.maxLines,
    this.onTap,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: const Color(0xff2E2E2E),
          filled: true,
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: prefixIcon,
          hintStyle: const TextStyle(
            color: Colors.grey,
          )),
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
