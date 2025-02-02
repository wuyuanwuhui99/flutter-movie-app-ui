import 'dart:io';

import 'package:flutter/material.dart';
import '../model/UserInfoModel.dart';
class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _userInfo;
  UserInfoProvider(this._userInfo);
  late String _version;
  late String _device;
  final String _platform = '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';

  void setUserInfo(UserInfoModel userInfo) {
    _userInfo = userInfo;
    notifyListeners(); //2
  }

  void setVersion(String version){
    _version = version;
  }

  void setDevice(String device){
    _device = device;
  }

  get userInfo => _userInfo;

  get version => _version;

  get device => _device;

  get platform => _platform;
}
