import 'package:flutter/material.dart';
import 'package:movie/theme/ThemeStyle.dart';
import '../../movie/service/serverMethod.dart';
import 'package:movie/router/index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
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
import '../../utils/HttpUtil .dart';
import '../../movie/model/CommentModel.dart';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({Key key}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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
  // 在父组件中创建 GlobalKey
  @override
  void initState() {
    super.initState();
    _lyricController = LyricController(vsync: this);
    player = Provider.of<PlayerMusicProvider>(context, listen: false).player;
    musicModel =
        Provider.of<PlayerMusicProvider>(context, listen: false).musicModel;
    usePlay(musicModel);
    _repeatController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // 创建一个从0到360弧度的补间动画 v * 2 * π
    _curveAnimation =
        Tween<double>(begin: 0, end: 1).animate(_repeatController);

    // 获取当前正在播放的音乐下标
    currentPlayIndex =
        Provider.of<PlayerMusicProvider>(context, listen: false).playIndex;

    playMusicModelList =
        Provider.of<PlayerMusicProvider>(context, listen: false)
            .playMusicModelList;
  }

  @override
  void dispose() {
    super.dispose();
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
        MediaQuery.of(context).size.width - ThemeSize.containerPadding * 6;
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

  Widget buildPlayMenu() {
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            "lib/assets/images/icon-music-collect.png",
            width: ThemeSize.playIcon,
            height: ThemeSize.playIcon,
          ),
          flex: 1,
        ),
        Expanded(
          child: Image.asset(
            "lib/assets/images/icon-music-down.png",
            width: ThemeSize.playIcon,
            height: ThemeSize.playIcon,
          ),
          flex: 1,
        ),
        Expanded(
          child: InkWell(
              child: Image.asset(
                "lib/assets/images/icon-music-comments.png",
                width: ThemeSize.playIcon,
                height: ThemeSize.playIcon,
              ),
              onTap: () async {
                print(musicModel);
                ResponseModel<List> res = await getTopCommentListService(
                    musicModel.id, CommentEnum.MUSIC, 1, 20);
                commentTotal = res.total != null ? res.total : 0;
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ThemeSize.middleRadius),
                            topRight: Radius.circular(ThemeSize.middleRadius))),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: CommentComponent(
                            type: CommentEnum.MUSIC,
                            relationId: musicModel.id,
                          ));
                    });
              }),
          flex: 1,
        ),
        Expanded(
          child: Image.asset(
            "lib/assets/images/icon-music-white-menu.png",
            width: ThemeSize.playIcon,
            height: ThemeSize.playIcon,
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
    List<MusicModel> playMusicModelList =
        Provider.of<PlayerMusicProvider>(context, listen: false)
            .playMusicModelList;
    return Row(
      children: [
        Expanded(
            child: Image.asset(
              "lib/assets/images/icon-music-order.png",
              width: ThemeSize.playIcon,
              height: ThemeSize.playIcon,
            ),
            flex: 1),
        Expanded(
            child: InkWell(
                child: Opacity(
                    opacity: currentPlayIndex == 0 ? 0.5 : 1,
                    child: Image.asset(
                      "lib/assets/images/icon-music-prev.png",
                      width: ThemeSize.playIcon,
                      height: ThemeSize.playIcon,
                    )),
                onTap: () {
                  if (currentPlayIndex > 0) {
                    Provider.of<PlayerMusicProvider>(context, listen: false)
                        .setPlayIndex(currentPlayIndex);
                    setState(() {
                      currentPlayIndex--;
                      musicModel = playMusicModelList[currentPlayIndex];
                    });
                  }
                }),
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
                              ? "lib/assets/images/icon-music-playing.png"
                              : "lib/assets/images/icon-music-play-white.png",
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
                child: Opacity(
                    opacity: currentPlayIndex == playMusicModelList.length - 1
                        ? 0.5
                        : 1,
                    child: Image.asset(
                      "lib/assets/images/icon-music-next.png",
                      width: ThemeSize.playIcon,
                      height: ThemeSize.playIcon,
                    )),
                onTap: useNextMusic),
            flex: 1),
        Expanded(
            child: Image.asset(
              "lib/assets/images/icon-music-play-menu.png",
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
      player.onDurationChanged.listen((event) {
        if (totalSec == 0) {
          setState(() {
            totalSec = event.inSeconds;
          });
        }
      });
      player.onAudioPositionChanged.listen((event) {
        _lyricController.progress = Duration(seconds: event.inSeconds);
        setState(() {
          duration = event.inSeconds;
          sliderValue = (duration / totalSec) * 100;
        });
      });
      player.onPlayerCompletion.listen((event) {
        useNextMusic(); // 切换下一首
      });
    }
  }

  void useNextMusic() {
    if (currentPlayIndex < playMusicModelList.length - 1) {
      setState(() {
        currentPlayIndex++;
        musicModel = playMusicModelList[currentPlayIndex];
      });
      Provider.of<PlayerMusicProvider>(context, listen: false)
          .setPlayIndex(currentPlayIndex);
    }
  }
}
