import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final Color? color;
  final double? iconSize;
  final Color? checkColor;
  final Function(int)? onChange;

  const MyCheckbox(
      {super.key,
      required this.title,
      this.width = 32,
      this.height = 32,
      this.color,
      this.iconSize,
      this.checkColor,
      this.onChange});

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  int isChecked = 0;
  void _onClicked() {
    setState(() {
      switch (isChecked) {
        case 0:
          isChecked = 1;
          break;
        case 1:
          isChecked = 2;
          break;
        default:
          isChecked = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => _onClicked(),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                color: isChecked == 1
                    ? Colors.red
                    : isChecked == 2
                        ? const Color(0xff5081DE)
                        : null,
                border:
                    Border.all(color: widget.color ?? Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(0.6)),
            child: Center(
              child: isChecked == 1
                  ? const Icon(Icons.schedule)
                  : isChecked == 2
                      ? const Icon(Icons.check)
                      : null,
            ),
          ),
        ),
        Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
