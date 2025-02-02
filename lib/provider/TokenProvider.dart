import 'package:flutter/material.dart';
class TokenProvider with ChangeNotifier {
  String _token;
  TokenProvider(this._token);

  void setToken(String token) {
    _token = token;
    // notifyListeners(); //2
  }

  get token => _token; //3
}
