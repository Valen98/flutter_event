class Request {
  String sender;
  String senderName;
  String recieverID;
  String recieverName;
  String? eventID;
  DateTime dateTime;
  String type;

  Request({
    required this.sender,
    required this.senderName,
    required this.recieverID,
    required this.recieverName,
    required this.dateTime,
    required this.type,
    this.eventID,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'senderName': senderName,
      'reciever': recieverID,
      'recieverName': recieverName,
      'dateTime': dateTime,
      'eventID': eventID,
      'type': type,
    };
  }
}
