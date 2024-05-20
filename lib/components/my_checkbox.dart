import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final String title;
  final String checkID;
  final int checkStatus;
  final double width;
  final double height;
  final Color? color;
  final double? iconSize;
  final Color? checkColor;
  final Function(String, int)? onChange;

  const MyCheckbox(
      {super.key,
      required this.checkID,
      required this.title,
      required this.checkStatus,
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
  late int checkStatus;

  @override
  void initState() {
    super.initState();
    checkStatus = widget.checkStatus;
  }

  void _onClicked() {
    setState(() {
      checkStatus = (checkStatus + 1) % 3;
    });
    widget.onChange?.call(widget.checkID, checkStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff1D1D1D)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkWell(
              onTap: _onClicked,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    color: checkStatus == 1
                        ? Colors.red
                        : checkStatus == 2
                            ? const Color(0xff5081DE)
                            : null,
                    border: Border.all(
                        color: widget.color ?? Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(0.6)),
                child: Center(
                  child: checkStatus == 1
                      ? const Icon(Icons.schedule)
                      : checkStatus == 2
                          ? const Icon(Icons.check)
                          : null,
                ),
              ),
            ),
            const SizedBox(width: 8.0), // Add some space between icon and text
            Expanded(
              // Use Expanded to allow the text to overflow
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
