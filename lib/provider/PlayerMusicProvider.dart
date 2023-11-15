import 'package:flutter/material.dart';
import '../model/MusicModel.dart';
import '../utils/LocalStroageUtils.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerMusicProvider with ChangeNotifier {
  MusicModel _musicModel; // 正在播放的音乐
  bool _playing = false;

  PlayerMusicProvider(this._musicModel);

  AudioPlayer _player = AudioPlayer();
  List<MusicModel> _playMusicModelList = []; // 正在播放的列表
  int _playIndex = 0; // 音乐播放的下标

  ///  @desc 设置正在播放额音乐
  ///  @data 2023-11-15 21:51
  ///  @author wuwenqiang
  void setPlayMusic(List<MusicModel> playMusicModelList, MusicModel musicModel,
      int playIndex, bool playing) {
    _musicModel = musicModel;
    _playing = playing;
    if (playMusicModelList.length > 0) {
      // 正在播放的列表
      _playMusicModelList = playMusicModelList;
      _playIndex = playIndex;
    }
    LocalStroageUtils.setPlayMusic(_musicModel);
    notifyListeners();
  }

  ///  @desc 通过缓存参数获取上次播放的音乐列表
  ///  @data 2023-11-15 21:51
  ///  @author wuwenqiang
  void setPlayMusicList(List<MusicModel> playMusicModelList) {
    _playMusicModelList = playMusicModelList;
    if (_musicModel == null) return;
    int playIndex = playMusicModelList.indexWhere((element) {
      // 查找正在播放的下标
      return element.id == _musicModel.id;
    });
    _playIndex = playIndex != -1 ? playIndex : _playIndex;
  }

  void setPlaying(bool playing) {
    _playing = playing;
    notifyListeners();
  }

  get playing => _playing;

  get musicModel => _musicModel;

  get player => _player;
}
