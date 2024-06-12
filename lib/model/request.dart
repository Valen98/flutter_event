class Request {
  String sender;
  String reciever;
  String? eventID;
  DateTime dateTime;
  String type;

  Request({
    required this.sender,
    required this.reciever,
    required this.dateTime,
    required this.type,
    this.eventID,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'reciever': reciever,
      'dateTime': dateTime,
      'eventID': eventID,
      'type': type,
    };
  }
}
