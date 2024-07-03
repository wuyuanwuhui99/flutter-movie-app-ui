import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie/theme/ThemeStyle.dart';
import 'package:movie/utils/LocalStroageUtils.dart';
import '../../main.dart';
import '../../movie/service/serverMethod.dart';
import 'package:movie/router/index.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/MusicModel.dart';
import '../../config/common.dart';
import '../../utils/common.dart';
import '../component/lyric/lyric_controller.dart';
import '../component/lyric/lyric_util.dart';
import '../component/lyric/lyric_widget.dart';
import '../component/CommentComponent.dart';
import '../component/FavoriteComponent.dart';
import '../../utils/HttpUtil .dart';
import '../service/serverMethod.dart';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({Key key}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, RouteAware {
  @override
  bool get wantKeepAlive => true;
  double sliderValue = 0;
  int duration = 0; // 已经播放额时间
  int totalSec = 0; // 总时间
  bool playState = false;
  MusicModel musicModel;
  AudioPlayer player;
  int currentPlayIndex = -1; // 当前播放音乐的下标
  List<MusicModel> playMusicModelList; // 播放的列表
  LyricController _lyricController; //歌词控制器
  AnimationController _repeatController; // 会重复播放的控制器
  Animation<double> _curveAnimation; // 非线性动画
  int commentTotal = 0;
  Map<LoopModeEnum, String> loopMode = {
    LoopModeEnum.ORDER: "lib/assets/images/icon_music_order.png",
    LoopModeEnum.REPEAT: "lib/assets/images/icon_music_loop.png",
    LoopModeEnum.RANDOM: "lib/assets/images/icon_music_random.png"
  };
  LoopModeEnum loopModeEnum;
  StreamSubscription onDurationChangedListener;// 监听总时长
  StreamSubscription onAudioPositionChangedListener;// 监听播放进度
  StreamSubscription onPlayerCompletionListener;// 监听播放完成
  bool loading = false;
  bool isFavorite = false;// 是否已经收藏

  @override
  void initState() {
    super.initState();
    _lyricController = LyricController(vsync: this);
    PlayerMusicProvider provider = Provider.of<PlayerMusicProvider>(context, listen: false);
    loopModeEnum =provider.loopMode;
    player = provider.player;
    musicModel = provider.musicModel;
    usePlay(musicModel);
    _repeatController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // 创建一个从0到360弧度的补间动画 v * 2 * π
    _curveAnimation = Tween<double>(begin: 0, end: 1).animate(_repeatController);

    // 获取当前正在播放的音乐下标
    currentPlayIndex = provider.playIndex;

    playMusicModelList = provider.playMusicList;

    useIsMusicFavorite(musicModel.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 添加监听订阅
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  ///@author: wuwenqiang
  ///@description: 退出当前页面，返回上一级页面
  ///@date: 2024-06-18 21:57
  @override
  void didPop() {
    super.didPop();
    onDurationChangedListener.cancel();// 取消监听音乐播放时长
    onAudioPositionChangedListener.cancel();// 取消监听音乐播放进度
  }

  @override
  void dispose() {
    super.dispose();
    // 移除监听订阅
    onDurationChangedListener.cancel();// 取消监听音乐播放时长
    onAudioPositionChangedListener.cancel();// 取消监听音乐播放进度
    MyApp.routeObserver.unsubscribe(this);
    _repeatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: Stack(children: [

          /// 图片在Stack最底层
          ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: 50, sigmaY: 50, tileMode: TileMode.mirror),
            child: Image.network(HOST + musicModel.cover,
                fit: BoxFit.cover,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ThemeSize.containerPadding * 2),
                Text(musicModel.songName,
                    style: TextStyle(
                        color: ThemeColors.colorWhite,
                        fontSize: ThemeSize.bigFontSize,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: ThemeSize.containerPadding),
                buildPlayCircle(),
                SizedBox(height: ThemeSize.containerPadding),
                Expanded(flex: 1, child: buildLyric()),
                SizedBox(height: ThemeSize.containerPadding),
                buildSinger(),
                SizedBox(height: ThemeSize.containerPadding),
                buildPlayMenu(),
                SizedBox(height: ThemeSize.containerPadding),
                buildprogress(),
                SizedBox(height: ThemeSize.containerPadding),
                buildPlayBtn(),
                SizedBox(height: ThemeSize.containerPadding)
              ],
            ),
          )
        ]));
  }

  Widget buildPlayCircle() {
    double playerWidth =
        MediaQuery
            .of(context)
            .size
            .width - ThemeSize.containerPadding * 6;
    return Container(
        width: playerWidth,
        height: playerWidth,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: ThemeColors.opcityColor,
          borderRadius: BorderRadius.circular(playerWidth),
        ),
        child: RotationTransition(
          turns: _curveAnimation,
          child: Container(
              width: playerWidth - ThemeSize.smallMargin,
              height: playerWidth - ThemeSize.smallMargin,
              margin: EdgeInsets.all(ThemeSize.smallMargin),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Color.fromRGBO(54, 57, 56, 1),
                    Color.fromRGBO(54, 57, 56, 1),
                    Colors.black,
                  ],
                ),
                borderRadius: BorderRadius.circular(playerWidth),
              ),
              child: Padding(
                  padding: EdgeInsets.all(ThemeSize.containerPadding * 4),
                  child: ClipOval(
                      child: Image.network(
                        HOST + musicModel.cover,
                        height: playerWidth -
                            ThemeSize.smallMargin -
                            ThemeSize.containerPadding * 3,
                        width: playerWidth -
                            ThemeSize.smallMargin -
                            ThemeSize.containerPadding * 3,
                        fit: BoxFit.cover,
                      )))),
        ));
  }

  Widget buildLyric() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: musicModel.lyrics != null && musicModel.lyrics != ''
              ? InkWell(
            child: LyricWidget(
              lyricStyle: TextStyle(
                  color: ThemeColors.opcityWhiteColor,
                  fontSize: ThemeSize.middleFontSize),
              currLyricStyle: TextStyle(
                  color: ThemeColors.colorWhite,
                  fontSize: ThemeSize.middleFontSize),
              size: Size(double.infinity, double.infinity),
              lyrics: LyricUtil.formatLyric(musicModel.lyrics),
              controller: _lyricController,
            ),
            onTap: () {
              Routes.router.navigateTo(context, '/MusicLyricPage');
            },
          )
              : Text('暂无歌词',
              style: TextStyle(
                  color: ThemeColors.opcityWhiteColor,
                  fontSize: ThemeSize.middleFontSize))),
    );
  }

  ///@author: wuwenqiang
  ///@description: 创建歌手
  /// @date: 2024-05-22 22:29
  Widget buildSinger() {
    return Row(
      children: [
        Expanded(
          child: Center(
              child: Text(musicModel.authorName,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: ThemeColors.colorWhite))),
          flex: 1,
        ),
        Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        Expanded(
          child: SizedBox(),
          flex: 1,
        ),
      ],
    );
  }

  ///@author: wuwenqiang
  ///@description: 创建底部弹窗
  /// @date: 2024-06-23 22:29
  void buildModalBottomSheet(Widget component){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ThemeSize.middleRadius),
                topRight: Radius.circular(ThemeSize.middleRadius))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              child: component
          );
        });
  }

  ///@author: wuwenqiang
  ///@description: 音乐播放操作
  /// @date: 2024-06-23 22:29
  Widget buildPlayMenu() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            child: Image.asset(
              musicModel.isLike == 0
                  ? "lib/assets/images/icon_music_collect.png"
                  : "lib/assets/images/icon_collection_active.png",
              width: ThemeSize.playIcon,
              height: ThemeSize.playIcon,
            ),
            onTap: () {
              if (loading) return;
              loading = true;
              PlayerMusicProvider provider = Provider.of<PlayerMusicProvider>(context, listen: false);
              if (musicModel.isLike == 0) {
                insertMusicLikeService(musicModel.id).then((res) {
                  loading = false;
                  if (res.data > 0) {
                    provider.setFavorite(1);
                    setState(() {
                      musicModel.isLike = 1;
                    });
                  }
                }).catchError(() {
                  loading = false;
                });
              } else {
                deleteMusicLikeService(musicModel.id).then((res) {
                  loading = false;
                  if (res.data > 0) {
                    provider.setFavorite(0);
                    setState(() {
                      musicModel.isLike = 0;
                    });
                  }
                }).catchError(() {
                  loading = false;
                });
              }
            },
          ),
          flex: 1,
        ),
        Expanded(
          child: Image.asset(
            "lib/assets/images/icon_music_down.png",
            width: ThemeSize.playIcon,
            height: ThemeSize.playIcon,
          ),
          flex: 1,
        ),
        Expanded(
          child: InkWell(
              child: Image.asset(
                "lib/assets/images/icon_music_comments.png",
                width: ThemeSize.playIcon,
                height: ThemeSize.playIcon,
              ),
              onTap: () async {
                print(musicModel);
                ResponseModel<List> res = await getTopCommentListService(
                    musicModel.id, CommentEnum.MUSIC, 1, 20);
                commentTotal = res.total != null ? res.total : 0;
                buildModalBottomSheet(CommentComponent(
                  type: CommentEnum.MUSIC,
                  relationId: musicModel.id,
                ));
              }),
          flex: 1,
        ),
        Expanded(
          child: InkWell(
            child: Image.asset(
              isFavorite ? "lib/assets/images/icon_full_star.png" : "lib/assets/images/icon_favorite.png",
              width: ThemeSize.playIcon,
              height: ThemeSize.playIcon,
            ),
            onTap: (){
              buildModalBottomSheet(FavoriteComponent(musicId: musicModel.id,isFavorite:isFavorite,onFavorite: (bool isMusicFavorite){
                Navigator.pop(context);
                setState(() {
                  isFavorite = isMusicFavorite;
                });
              },));
            },
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget buildprogress() {
    return Row(
      children: [
        SizedBox(width: ThemeSize.containerPadding * 2),
        Text(getDuration(duration),
            style: TextStyle(color: ThemeColors.colorWhite)),
        Expanded(
          child: Slider(
            value: sliderValue,
            onChanged: (data) {
              player.seek(Duration(seconds:totalSec*data~/100));
              setState(() {
                sliderValue = data;
              });
            },
            onChangeStart: (data) {
              print('start:$data');
            },
            onChangeEnd: (data) {
              print('end:$data');
            },
            min: 0,
            max: 100.0,
            activeColor: ThemeColors.opcityWhiteColor,
            inactiveColor: ThemeColors.opcityColor,
          ),
          flex: 1,
        ),
        Text(getDuration(totalSec),
            style: TextStyle(color: ThemeColors.colorWhite)),
        SizedBox(width: ThemeSize.containerPadding * 2),
      ],
    );
  }

  Widget buildPlayBtn() {
    PlayerMusicProvider provider = Provider.of<PlayerMusicProvider>(context, listen: false);
    return Row(
      children: [
        Expanded(
            child:
            PopupMenuButton<LoopModeEnum>(
              color: ThemeColors.popupMenuColor,
              initialValue: loopModeEnum,
              child: Image.asset(
                loopMode[loopModeEnum],
                width: ThemeSize.playIcon,
                height: ThemeSize.playIcon,
              ),
              onSelected: (LoopModeEnum loopMode) {
                provider.setLoopMode(loopMode);
                LocalStroageUtils.setLoopMode(loopMode);
                setState(() {
                  loopModeEnum = loopMode;
                });
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<LoopModeEnum>>[
                  PopupMenuItem<LoopModeEnum>(
                      value: LoopModeEnum.ORDER,
                      child: Row(
                          children: <Widget>[
                            Image.asset(
                                "lib/assets/images/icon_music_order.png",
                                width: ThemeSize.smallIcon,
                                height: ThemeSize.smallIcon),
                            SizedBox(width: ThemeSize.smallMargin),
                            Text(
                                '顺序播放', style: TextStyle(color: ThemeColors.colorWhite))
                          ])
                  ),
                  PopupMenuItem<LoopModeEnum>(
                    value: LoopModeEnum.REPEAT,
                    child: Row(
                        children: <Widget>[
                          Image.asset('lib/assets/images/icon_music_loop.png',
                              width: ThemeSize.smallIcon,
                              height: ThemeSize.smallIcon),
                          SizedBox(width: ThemeSize.smallMargin),
                          Text('单曲循环',
                              style: TextStyle(color: ThemeColors.colorWhite))
                        ]),
                  ),
                  PopupMenuItem<LoopModeEnum>(
                    value: LoopModeEnum.RANDOM,
                    child: Row(
                        children: <Widget>[
                          Image.asset('lib/assets/images/icon_music_random.png',
                              width: ThemeSize.smallIcon,
                              height: ThemeSize.smallIcon),
                          SizedBox(width: ThemeSize.smallMargin),
                          Text('随机播放',
                              style: TextStyle(color: ThemeColors.colorWhite))
                        ]),
                  )
                ];
              },
            )
            ,
            flex: 1),
        Expanded(
            child: InkWell(
                child: Image.asset(
                  "lib/assets/images/icon_music_prev.png",
                  width: ThemeSize.playIcon,
                  height: ThemeSize.playIcon,
                ),
                onTap: usePrevMusic),
            flex: 1),
        Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                      width: ThemeSize.bigAvater,
                      height: ThemeSize.bigAvater,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(ThemeSize.bigAvater),
                        border:
                        Border.all(color: ThemeColors.colorWhite, width: 2),
                      ),
                      child: Center(
                        child: Image.asset(
                          playState
                              ? "lib/assets/images/icon_music_playing.png"
                              : "lib/assets/images/icon_music_play_white.png",
                          width: ThemeSize.playIcon,
                          height: ThemeSize.playIcon,
                        ),
                      )),
                  onTap: () {
                    if (playState) {
                      player.pause();
                      setState(() {
                        playState = false;
                      });
                      _repeatController.stop(canceled: false);
                    } else {
                      player.resume();
                      setState(() {
                        playState = true;
                      });
                      _repeatController.forward();
                      _repeatController.repeat();
                    }
                  },
                )
              ],
            ),
            flex: 2),
        Expanded(
            child: InkWell(
                child: Image.asset(
                  "lib/assets/images/icon_music_next.png",
                  width: ThemeSize.playIcon,
                  height: ThemeSize.playIcon,
                ),
                onTap: useNextMusic),
            flex: 1),
        Expanded(
            child: Image.asset(
              "lib/assets/images/icon_music_play_menu.png",
              width: ThemeSize.playIcon,
              height: ThemeSize.playIcon,
            ),
            flex: 1),
      ],
    );
  }

  /// 播放音乐
  void usePlay(MusicModel musicModel) async {
    final result = await player.play(HOST + musicModel.localPlayUrl);
    if (result == 1) {
      setState(() {
        // 默认开始播放
        playState = true;
      });
      onDurationChangedListener?.cancel();// 恢复监听音乐播放时长
      onAudioPositionChangedListener?.cancel();// 恢复监听音乐播放进度
      onDurationChangedListener = player.onDurationChanged.listen((event) {
        setState(() {
          totalSec = event.inSeconds;
        });
      });
      onAudioPositionChangedListener = player.onAudioPositionChanged.listen((event) {
        _lyricController.progress = Duration(seconds: event.inSeconds);
        setState(() {
          duration = event.inSeconds;
          sliderValue = (duration / totalSec) * 100;
        });
      });
      onPlayerCompletionListener?.cancel();
      onPlayerCompletionListener = player.onPlayerCompletion.listen((event) {
        useNextMusic(); // 切换下一首
      });
    }
  }

  ///@author: wuwenqiang
  ///@description: 切换上一首
  /// @date: 2024-06-21 23:12
  usePrevMusic(){
    PlayerMusicProvider provider = Provider.of<PlayerMusicProvider>(context, listen: false);
    if(loopModeEnum == LoopModeEnum.RANDOM){// 随机播放
      if(provider.playMusicList.length > 1){ // 如果已经播放的音乐两首以上，回退上一首
        MusicModel prevMusic = provider.playMusicList[provider.playMusicList.length - 2];
        provider.playMusicList.removeAt(provider.playMusicList.length - 1);
        currentPlayIndex = provider.musicList.indexWhere((item)=>item.id == prevMusic.id);
      }else if(currentPlayIndex == 0){// 如果已经播放的歌曲只有一首，切换上一首
        currentPlayIndex = provider.musicList.length - 1;
      }else{
        currentPlayIndex -= 1;
      }
    }else{
      if (currentPlayIndex > 0) {
        currentPlayIndex--;
      } else {
        currentPlayIndex = provider.musicList.length - 1;
      }
    }
    useIsMusicFavorite(provider.musicList[currentPlayIndex].id);
    setState(() {
      musicModel = provider.musicList[currentPlayIndex];
    });
    provider.setPlayIndex(currentPlayIndex);
  }

  void useIsMusicFavorite(musicId){
    isMusicFavoriteService(musicId).then((value){
      setState(() {
        isFavorite = value.data > 0;
      });
    });
  }

  ///@author: wuwenqiang
  ///@description: 切换下一首歌曲
  /// @date: 2024-06-14 00:15
  void useNextMusic() {
    PlayerMusicProvider provider = Provider.of<PlayerMusicProvider>(context, listen: false);
    if(loopModeEnum == LoopModeEnum.RANDOM){
      int index = Random().nextInt(provider.unPlayMusicList.length - 1);
      currentPlayIndex = provider.musicList.indexWhere((item) => item.id == provider.unPlayMusicList[index].id);
    }else{
      if (currentPlayIndex < provider.musicList.length - 1) {
        currentPlayIndex++;
      } else {
        currentPlayIndex = 0;
      }
    }
    this.useIsMusicFavorite(provider.musicList[currentPlayIndex].id);
    setState(() {
      musicModel = provider.musicList[currentPlayIndex];
    });
    provider.setPlayIndex(currentPlayIndex);
  }
}