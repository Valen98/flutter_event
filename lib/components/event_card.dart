import 'dart:math';
import 'package:event/pages/event_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

    Map<String, Color> colors = {
      'Purple': const Color(0xff533AC7),
      'Green': const Color(0xff3AC762),
      'Pink': const Color(0xffC73A80),
      'Yellow': const Color(0xffFAC234),
      'Red': const Color(0xffCC1A1A),
      'Orange': const Color(0xffE0831F)
    };

    return Container(
      width: 350, // Fixed width
      height: 180,
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: event['color'] != "" && event['color'] != null
            ? colors[event['color']]
            : const Color(0xff533AC7),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  event: event,
                ),
              ),
            );
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: 350, // Fixed width
              height: 180,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xff1D1D1D),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121212).withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['eventName'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: event['eventDesc'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              (dateFormat.format(event['eventDate'].toDate())),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Spacer(), // Add a spacer to push elements to the sides
                            const Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8.0),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
