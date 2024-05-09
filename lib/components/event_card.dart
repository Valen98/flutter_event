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
    Random random = Random();
    int randNumber = random.nextInt(5);
    List<Color> colors = [
      const Color(0xff533AC7),
      const Color(0xff3AC762),
      const Color(0xffC73A80),
      const Color(0xffC79F3A),
      const Color(0xffC7a1B6),
      const Color(0xff3AC7A3)
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventPage(
                      event: event,
                    )));
      },
      child: Container(
        width: 350,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors[randNumber],
          boxShadow: [
            BoxShadow(
                color: const Color(0xff121212).withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(3, 5))
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.only(
              top: 25,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff1D1D1D)),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text at the start
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        event['eventName'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 320,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: event['eventDesc'],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                (dateFormat
                                    .format(event['eventDate'].toDate())),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Location',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
