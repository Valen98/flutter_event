import 'package:flutter/material.dart';

class EventRequest extends StatefulWidget {
  final Map<String, dynamic> request;
  const EventRequest({super.key, required this.request});

  @override
  State<EventRequest> createState() => _EventRequestState();
}

class _EventRequestState extends State<EventRequest> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.request['senderName'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green,
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(child: Icon(Icons.add)),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red,
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(child: Icon(Icons.remove)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
