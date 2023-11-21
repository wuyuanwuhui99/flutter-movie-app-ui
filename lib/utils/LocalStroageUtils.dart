import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../music//model/MusicModel.dart';
import '../music//model/ClassMusicParamsModel.dart';

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
    if (playMusic != null) {
      return json.decode(playMusic);
    } else {
      return null;
    }
  }

  ///  @desc 从缓存中获取正在播放的列表的参数
  ///  @data 2023-11-15 21:01
  ///  @author wuwenqiang
  static Future getClassMusicParams() async {
    final SharedPreferences prefs = await _prefs;
    String classMusicParams = prefs.getString('classMusicParams') ?? null;
    if (classMusicParams != null) {
      return ClassMusicParamsModel.fromJson(json.decode(classMusicParams));
    } else {
      return null;
    }
  }
}
