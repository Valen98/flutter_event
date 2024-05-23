import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/announcement_card.dart';
import 'package:event/components/my_button.dart';
import 'package:event/components/my_text_field.dart';
import 'package:event/services/event/event_announcement_service.dart';
import 'package:flutter/material.dart';

class EventAnnouncements extends StatefulWidget {
  final Map<String, dynamic> event;
  const EventAnnouncements({super.key, required this.event});

  @override
  State<EventAnnouncements> createState() => _EventAnnouncementsState();
}

class _EventAnnouncementsState extends State<EventAnnouncements> {
  final TextEditingController annoucnemntController = TextEditingController();
  final EventAnnouncementService _announcementService =
      EventAnnouncementService();

  Future<void> _openModal() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: _dialog());
        });
  }

  Dialog _dialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xff1D1D1D),
          ),
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: annoucnemntController,
                    hintText: "Announcement",
                    obscureText: false,
                    readOnly: false,
                    maxLines: null,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: MyButton(
                        bgColor: const Color.fromARGB(255, 51, 48, 222),
                        onTap: () async {
                          await _announcementService.createAnnouncement(
                              annoucnemntController.text,
                              widget.event['eventID']);
                          Navigator.pop(context);
                        },
                        text: "Post it!",
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: MyButton(
                        bgColor: const Color(0xffC92A2A),
                        onTap: () async {
                          Navigator.pop(context);
                          annoucnemntController.clear();
                        },
                        text: "Cancel",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: _openModal,
              child: const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      Text("Make an announcement"),
                      Icon(
                        Icons.add_box,
                        color: Color(0xff533AC7),
                      )
                    ],
                  ))),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _announcementService
                  .getAnnouncements(widget.event['eventID']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var announcements =
                      snapshot.data!.docs.map((doc) => doc.data()).toList();
                  if (announcements.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          var announcement = announcements[index];
                          return AnnouncementCard(announcement: announcement);
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "No announcements found!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
