import 'package:flutter/material.dart';
import '../model/MusicModel.dart';
import '../utils/LocalStroageUtils.dart';

class PlayerMusicProvider with ChangeNotifier {
  MusicModel _musicModel;// 正在播放的音乐
  bool _playing = false;
  PlayerMusicProvider(this._musicModel);

  void setPlayMusic(MusicModel musicModel,bool playing) {
    _musicModel = musicModel;
    _playing = playing;
    LocalStroageUtils.setPlayMusic(_musicModel);
    notifyListeners();
  }

  void setPlaying(bool playing){
    _playing = playing;
    notifyListeners();
  }

  get playing => _playing;

  get musicModel => _musicModel;
}
