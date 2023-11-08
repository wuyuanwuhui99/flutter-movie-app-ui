import 'package:flutter/material.dart';
import '../theme/ThemeSize.dart';
import 'dart:ui';
import '../theme/ThemeColors.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/MusicModel.dart';
import '../config/serviceUrl.dart';
import '../utils/common.dart';

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

  /// 会重复播放的控制器
  AnimationController _repeatController;

  /// 非线性动画
  Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
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
            child: Image.network(host + musicModel.cover,
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
                SizedBox(height: ThemeSize.containerPadding * 4),
                Text(musicModel.songName,
                    style: TextStyle(
                        color: ThemeColors.colorWhite,
                        fontSize: ThemeSize.bigFontSize,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: ThemeSize.containerPadding * 2),
                buildPlayCircle(),
                SizedBox(
                  height: ThemeSize.containerPadding * 3,
                ),
                buildLyric(),
                SizedBox(height: ThemeSize.containerPadding),
                buildPlayMenu(),
                SizedBox(height: ThemeSize.containerPadding),
                buildprogress(),
                SizedBox(height: ThemeSize.containerPadding * 2),
                buildPlayBtn()
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
                    host + musicModel.cover,
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
    return Column(children: [
      Text("依然记得从你眼中", style: TextStyle(color: ThemeColors.colorWhite)),
      SizedBox(height: ThemeSize.containerPadding),
      Text("滑落的泪伤心欲绝", style: TextStyle(color: ThemeColors.opcityWhiteColor)),
      SizedBox(height: ThemeSize.containerPadding),
      Row(
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
      )
    ]);
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
          child: Image.asset(
            "lib/assets/images/icon-music-comments.png",
            width: ThemeSize.playIcon,
            height: ThemeSize.playIcon,
          ),
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
            child: Image.asset(
              "lib/assets/images/icon-music-prev.png",
              width: ThemeSize.playIcon,
              height: ThemeSize.playIcon,
            ),
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
                    } else {
                      player.resume();
                      setState(() {
                        playState = true;
                      });
                    }
                  },
                )
              ],
            ),
            flex: 2),
        Expanded(
            child: Image.asset(
              "lib/assets/images/icon-music-next.png",
              width: ThemeSize.playIcon,
              height: ThemeSize.playIcon,
            ),
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
    final result = await player.play(host + musicModel.localPlayUrl);
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
        setState(() {
          duration = event.inSeconds;
          sliderValue = (duration / totalSec) * 100;
        });
      });
    }
  }
}
