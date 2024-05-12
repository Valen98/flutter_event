class MyUser {
  String displayName;
  String email;
  String uid;
  List<dynamic> friends;
  List<dynamic> events;

  MyUser(
      {required this.displayName,
      required this.email,
      required this.uid,
      required this.friends,
      required this.events});

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'uid': uid,
      'friends': friends,
      'events': events
    };
  }
}
