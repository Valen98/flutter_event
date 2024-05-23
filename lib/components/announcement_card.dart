import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementCard extends StatefulWidget {
  final Map<String, dynamic> announcement;
  const AnnouncementCard({super.key, required this.announcement});

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  bool isExpanded = false;
  final DateFormat dateFormat = DateFormat("dd/MM HH:mm");

  @override
  Widget build(BuildContext context) {
    final String displayName = widget.announcement['displayName'];
    final DateTime created = widget.announcement['created'].toDate();
    final String announcementText = widget.announcement['announcement'];
    final bool shouldShowReadMore =
        announcementText.length > 30; // Adjust character length as needed

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 350,
            constraints: const BoxConstraints(
              minHeight: 140, // Set minimum height
            ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dateFormat.format(created),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    announcementText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: isExpanded ? null : 3,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (shouldShowReadMore)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(isExpanded ? 'Read less' : 'Read more'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
