import 'package:shared_preferences/shared_preferences.dart';

class LocalStroageUtils {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //从缓存中获取token
  static Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token') ?? '';
    return token;
  }

  //保存token
  static Future setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", token);
  }
}
