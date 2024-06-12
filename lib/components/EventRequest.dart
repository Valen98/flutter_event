import 'package:event/services/event/event_service.dart';
import 'package:flutter/material.dart';

class EventRequest extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  const EventRequest(
      {super.key, required this.request, required this.onAccept});

  @override
  State<EventRequest> createState() => _EventRequestState();
}

class _EventRequestState extends State<EventRequest> {
  final EventService _eventService = EventService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.request['eventName'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  //Accept the invite
                  _eventService.acceptEventRequest(
                      widget.request['reciever'], widget.request['eventID']);

                  //Delete the invite
                  _eventService.removeEventRequest(widget.request['reciever'],
                      widget.request['sender'], widget.request['requestID']);

                  widget.onAccept();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green,
                  ),
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
