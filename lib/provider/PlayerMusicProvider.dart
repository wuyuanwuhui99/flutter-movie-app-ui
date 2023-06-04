import 'package:flutter/material.dart';
import '../model/MusicModel.dart';

class PlayerMusicProvider with ChangeNotifier {
  MusicModel _musicModel;// 正在播放的音乐
  PlayerMusicProvider(this._musicModel);

  void setPlayMusic(MusicModel musicModel) {
    _musicModel = musicModel;
    notifyListeners();
  }

  get musicModel => _musicModel;
}
