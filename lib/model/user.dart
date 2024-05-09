class MyUser {
  String displayName;
  String email;
  String uid;

  MyUser({required this.displayName, required this.email, required this.uid});

  Map<String, dynamic> toMap() {
    return {'displayName': displayName, 'email': email, 'uid': uid};
  }
}
