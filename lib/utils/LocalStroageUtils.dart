import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/MusicModel.dart';

class LocalStroageUtils {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //从缓存中获取token
  static Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token') ?? '';
  }

  //保存token
  static Future setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", token);
  }

  static Future setPlayMusic(MusicModel musicModel) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("playMusic", MusicModel.stringigy(musicModel));
  }

  static Future getPlayMusic() async {
    final SharedPreferences prefs = await _prefs;
    String playMusic = prefs.getString('playMusic') ?? null;
    if(playMusic != null){
      return json.decode(playMusic);
    }else{
      return null;
    }
  }
}
