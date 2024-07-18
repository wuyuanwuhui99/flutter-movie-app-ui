import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/LocalStorageUtils.dart';
import '../../common/constant.dart';
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
  List<MusicModel> _musicList = []; // 所有音乐
  List<MusicModel> _playMusicList = [];// 已经播放过的音乐
  List<MusicModel> _unPlayMusicList = []; // 待播放的歌曲列表
  int _playIndex = 0; // 音乐播放的下标
  String _classifyName = '';// 分类的名称
  LoopModeEnum _loopMode = LoopModeEnum.ORDER;

  ///  @desc 设置正在播放额音乐
  ///  @data 2023-11-15 21:51
  ///  @author wuwenqiang
  void setPlayMusic(MusicModel musicModel, bool playing) {
    _musicModel = musicModel;
    _playing = playing;
    if (_musicList.length > 0) {
      // 正在播放的列表
      _playIndex = _musicList.indexWhere((element) => element.id == _musicModel.id);
    }
    _playMusicList = <MusicModel>[];
    removeMusic();
    if(playing)insertMusicRecordService(_musicModel);// 插入播放记录
    LocalStorageUtils.setPlayMusic(_musicModel);
    notifyListeners();
  }

  ///  @desc 插入一首歌曲
  ///  @data 2024-07-09 23:54
  ///  @author wuwenqiang
  insertMusic(MusicModel musicModel,int playIndex){
    if(_playIndex == playIndex){
      _musicModel = musicModel;
    }
    _musicList.insert(playIndex, musicModel);
  }

  ///  @desc 设置音乐是否收藏
  ///  @data 2023-11-15 21:51
  ///  @author wuwenqiang
  void setFavorite(int isLike) {
    _musicModel.isLike = isLike;
    LocalStorageUtils.setPlayMusic(_musicModel);
    notifyListeners();
  }

  ///  @desc 设置分类音乐
  ///  @data 2024-07-18 23:55
  ///  @author wuwenqiang
  void setClassifyMusic(List<MusicModel> musicList,index,classifyName){
    _musicModel = musicList[index];
    _musicList = musicList;
    _classifyName = classifyName;
    _playMusicList = [];
    _unPlayMusicList =  List.from(musicList);
    _playing = true;
    LocalStorageUtils.setPlayMusic(_musicModel);
    LocalStorageUtils.setMusicList(_musicList);
    LocalStorageUtils.setClassifyName(_classifyName);
  }

  ///  @desc 通过缓存参数获取上次播放的音乐列表
  ///  @data 2023-11-15 21:51
  ///  @author wuwenqiang
  void setMusicList(List<MusicModel> musicList) {
    _musicList = musicList;
    _playMusicList = <MusicModel>[];
    _unPlayMusicList = List.from(musicList);
    LocalStorageUtils.setMusicList(_musicList);
    if (_musicModel == null) return;
    int playIndex = musicList.indexWhere((element) => element.id == _musicModel.id);
    _playIndex = playIndex != -1 ? playIndex : _playIndex;
    removeMusic();
    notifyListeners();
  }

  void removeMusic(){
    int playIndex = _unPlayMusicList.indexWhere((element) => element.id == _musicModel.id);
    if(playIndex != -1){
      MusicModel playMusicModel = _unPlayMusicList.removeAt(playIndex);
      if(!_playMusicList.contains((item) => item.id == _unPlayMusicList[playIndex].id)){
        _playMusicList.add(playMusicModel);
      }
    }
  }

  void setPlaying(bool playing) {
    _playing = playing;
    notifyListeners();
  }

  ///  @desc 设置上一首获取下一首
  ///  @data 2023-11-17 21:47
  ///  @author wuwenqiang
  void setPlayIndex(int playIndex){
    if(playIndex <= _musicList.length - 1 && playIndex >= 0){
      _musicModel = _musicList[playIndex];
      _playIndex = playIndex;
      insertMusicRecordService(_musicModel);
      LocalStorageUtils.setPlayMusic(_musicModel);
      _player.play(HOST + _musicModel.localPlayUrl);
      removeMusic();
      notifyListeners();
    }
  }

  void setLoopMode(LoopModeEnum loopMode){
    _loopMode = loopMode;
    notifyListeners();
  }

  get classifyName => _classifyName;

  get playing => _playing;

  get musicModel => _musicModel;

  get player => _player;

  get playIndex => _playIndex;

  get musicList => _musicList;

  get loopMode => _loopMode;

  get unPlayMusicList => _unPlayMusicList;

  get playMusicList => _playMusicList;
}
