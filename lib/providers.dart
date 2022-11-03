import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final UserLoggedInProvider =
    ChangeNotifierProvider<UserLoggedIn>((ref) => UserLoggedIn());

class UserLoggedIn extends ChangeNotifier {
  bool isUserSignedIn = false;
  String usernameSession = "";

  void setUserCurrentState(userState) {
    isUserSignedIn = userState;
    notifyListeners();
  }

  bool getUserCurrentState() {
    return isUserSignedIn;
  }

  void setUsername(username) {
    usernameSession = username;
    notifyListeners();
  }

  String getUsername() {
    return usernameSession;
  }
}
