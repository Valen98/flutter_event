class Request {
  String sender;
  String senderName;
  String recieverID;
  String recieverName;
  String? eventID;
  String? eventName;
  DateTime dateTime;
  String type;
  String requestID;

  Request({
    required this.sender,
    required this.senderName,
    required this.recieverID,
    required this.recieverName,
    required this.dateTime,
    required this.type,
    this.eventID,
    this.eventName,
    required this.requestID,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'senderName': senderName,
      'reciever': recieverID,
      'recieverName': recieverName,
      'dateTime': dateTime,
      'type': type,
      'eventID': eventID,
      'eventName': eventName,
      'requestID': requestID,
    };
  }
}
