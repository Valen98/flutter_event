import 'package:event/services/user/user_service.dart';
import 'package:flutter/material.dart';

class FriendRequest extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  const FriendRequest(
      {super.key, required this.request, required this.onAccept});

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  final UserService _userService = UserService();
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
              InkWell(
                onTap: () {
                  //Accept the invite
                  _userService.acceptFriendRequest(
                      widget.request['sender'], widget.request['reciever']);

                  //Delete the invite
                  _userService.removeFriendRequest(widget.request['reciever'],
                      widget.request['sender'], widget.request['requestID']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.request['senderName']} Added'),
                    ),
                  );
                  widget.onAccept();
                },
                borderRadius: BorderRadius.circular(16),
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
