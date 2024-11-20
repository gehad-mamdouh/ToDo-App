import 'package:flutter/cupertino.dart';

import '../models/my_user.dart';

class AuthUserProvider extends ChangeNotifier {
  MyUser? currentUser;

  void updateUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
