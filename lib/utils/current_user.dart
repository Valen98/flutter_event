import 'package:event/model/user.dart';

class CurrentUser {
  static final CurrentUser _singleton = CurrentUser._internal();

  factory CurrentUser() {
    return _singleton;
  }

  CurrentUser._internal();

  MyUser? _currentUser;

  MyUser? get user => _currentUser;

  void setUser(MyUser user) {
    _currentUser = user;
  }

  void clearUser() {
    _currentUser = null;
  }

  static CurrentUser get instance {
    return CurrentUser._internal();
  }
}
