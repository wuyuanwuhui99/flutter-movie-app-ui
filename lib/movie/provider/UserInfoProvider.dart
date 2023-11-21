import 'package:flutter/material.dart';
import '../model/UserInfoModel.dart';
class UserInfoProvider with ChangeNotifier {
  UserInfoModel _userInfo;
  UserInfoProvider(this._userInfo);

  void setUserInfo(UserInfoModel userInfo) {
    _userInfo = userInfo;
    notifyListeners(); //2
  }

  get userInfo => _userInfo; //3
}
