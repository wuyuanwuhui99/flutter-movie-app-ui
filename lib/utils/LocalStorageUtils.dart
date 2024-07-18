import 'dart:convert';

import 'package:movie/music/provider/PlayerMusicProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../music/model/MusicModel.dart';
import '../music/model/ClassMusicParamsModel.dart';
import '../common/constant.dart';

class LocalStorageUtils {
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
    prefs.setString(MUSIC_STORAGE_KEY, MusicModel.stringify(musicModel));
  }

  static Future<MusicModel> getPlayMusic() async {
    final SharedPreferences prefs = await _prefs;
    String playMusic = prefs.getString(MUSIC_STORAGE_KEY) ?? null;
    if (playMusic != null) {
      return MusicModel.fromJson(json.decode(playMusic));
    } else {
      return null;
    }
  }

  ///  @desc 从缓存中获取正在播放的列表
  ///  @data 2024-7-18 23:14
  ///  @author wuwenqiang
  static Future<List<MusicModel>> getMusicList() async {
    final SharedPreferences prefs = await _prefs;
    String playMusic = prefs.getString(MUSIC_LIST_STORAGE_KEY) ?? null;
    if (playMusic != null) {
      List<Map> musicList = json.decode(playMusic);
      return musicList.map((e) => MusicModel.fromJson(e));
    } else {
      return [];
    }
  }

  ///  @desc 从缓存中获取正在播放的列表
  ///  @data 2024-7-18 23:14
  ///  @author wuwenqiang
  static Future setMusicList(List<MusicModel> musicList) async {
    final SharedPreferences prefs = await _prefs;
    List<Map> myMusicList = musicList.map((e) => MusicModel.toMap(e));
    prefs.setString(MUSIC_LIST_STORAGE_KEY, json.encode(myMusicList));
  }


  ///  @desc 从缓存中获取正在播放的列表的参数
  ///  @data 2023-11-15 21:01
  ///  @author wuwenqiang
  static Future setLoopMode(LoopModeEnum loopModeEnum) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(LOOP_STORAGE_KEY, loopModeEnum.toString());
  }

  ///  @desc 获取缓存的枚举值
  ///  @data 2023-11-15 21:01
  ///  @author wuwenqiang
  static Future<LoopModeEnum> getLoopMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(LOOP_STORAGE_KEY) != null ? LoopModeEnum.values.firstWhere((e) => e.toString() == prefs.getString("loopMode")) : LoopModeEnum.ORDER;
  }

  ///  @desc 把分类名称存入缓存
  ///  @data 2024-07-18 23:37
  ///  @author wuwenqiang
  static Future setClassifyName(String classifyName) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(MUSIC_CLASSIFY_NAME_STORAGE_KEY, classifyName);
  }

  ///  @desc 从缓存中获取正在播放的分类名称
  ///  @data 2023-11-15 21:01
  ///  @author wuwenqiang
  static Future<String> getClassifyName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(MUSIC_CLASSIFY_NAME_STORAGE_KEY) ?? null;
  }
}
