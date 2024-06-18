import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/LocalStroageUtils.dart';
import '../../config/common.dart';
import '../service/serverMethod.dart';
import '../model/MusicModel.dart';

enum  LoopModeEnum {
  ORDER,// 顺序播放
  RANDOM,// 随机播放
  REPEAT// 单曲循环
}

class PlayerMusicProvider with ChangeNotifier {
  MusicModel _musicModel; // 正在播放的音乐
  bool _playing = false;
  PlayerMusicProvider(this._musicModel);
  AudioPlayer _player = AudioPlayer();
  List<MusicModel> _playMusicModelList = []; // 正在播放的列表
  List<MusicModel> _unPlayMusicModelList = []; // 待播放的歌曲列表
  int _playIndex = 0; // 音乐播放的下标
  LoopModeEnum _loopMode = LoopModeEnum.ORDER;

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
    removeMusic();
    if(playing)insertMusicRecordService(_musicModel);// 插入播放记录
    LocalStroageUtils.setPlayMusic(_musicModel);
    notifyListeners();
  }

  ///  @desc 通过缓存参数获取上次播放的音乐列表
  ///  @data 2023-11-15 21:51
  ///  @author wuwenqiang
  void setPlayMusicList(List<MusicModel> playMusicModelList) {
    _playMusicModelList = playMusicModelList;
    _unPlayMusicModelList = List.from(playMusicModelList);
    if (_musicModel == null) return;
    int playIndex = playMusicModelList.indexWhere((element) => element.id == _musicModel.id);
    _playIndex = playIndex != -1 ? playIndex : _playIndex;
    removeMusic();
    notifyListeners();
  }

  void removeMusic(){
    int playIndex = _unPlayMusicModelList.indexWhere((element) => element.id == _musicModel.id);
    if(playIndex != -1)_unPlayMusicModelList.removeAt(playIndex);
  }

  void setPlaying(bool playing) {
    _playing = playing;
    notifyListeners();
  }

  ///  @desc 设置上一首获取下一首
  ///  @data 2023-11-17 21:47
  ///  @author wuwenqiang
  void setPlayIndex(int playIndex){
    if(playIndex <= _playMusicModelList.length - 1 && playIndex >= 0){
      _musicModel = _playMusicModelList[playIndex];
      _playIndex = playIndex;
      insertMusicRecordService(_musicModel);
      LocalStroageUtils.setPlayMusic(_musicModel);
      _player.play(HOST + _musicModel.localPlayUrl);
      removeMusic();
      notifyListeners();
    }
  }

  void setLoopMode(LoopModeEnum loopMode){
    _loopMode = loopMode;
    notifyListeners();
  }

  get playing => _playing;

  get musicModel => _musicModel;

  get player => _player;

  get playIndex => _playIndex;

  get playMusicModelList => _playMusicModelList;

  get loopMode => _loopMode;
}
