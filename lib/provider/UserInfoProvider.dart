import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  Map _userInfo;
  UserInfoProvider(this._userInfo);

  void setUserInfo(Map userInfo) {
    _userInfo = userInfo;
    notifyListeners(); //2
  }

  get userInfo => _userInfo; //3
}
