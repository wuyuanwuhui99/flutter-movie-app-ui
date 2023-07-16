import 'package:flutter/material.dart';
import '../theme/ThemeSize.dart';
import 'dart:ui';
import '../theme/ThemeColors.dart';
import 'package:provider/provider.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/MusicModel.dart';
import '../config/serviceUrl.dart';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({Key key}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double _sliderValue = 20;

  @override
  Widget build(BuildContext context) {
    double playerWidth =
        MediaQuery.of(context).size.width - ThemeSize.containerPadding * 6;
    MusicModel musicModel =
        Provider.of<PlayerMusicProvider>(context).musicModel;
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
                Container(
                    width: playerWidth,
                    height: playerWidth,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: ThemeColors.opcityColor,
                      borderRadius: BorderRadius.circular(playerWidth),
                    ),
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
                            padding:
                                EdgeInsets.all(ThemeSize.containerPadding * 4),
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
                            ))))),
                SizedBox(
                  height: ThemeSize.containerPadding * 3,
                ),
                Text("依然记得从你眼中",
                    style: TextStyle(color: ThemeColors.colorWhite)),
                SizedBox(height: ThemeSize.containerPadding),
                Text("滑落的泪伤心欲绝",
                    style: TextStyle(color: ThemeColors.opcityWhiteColor)),
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
                ),
                SizedBox(height: ThemeSize.containerPadding),
                Row(
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
                ),
                SizedBox(height: ThemeSize.containerPadding),
                Row(
                  children: [
                    SizedBox(width: ThemeSize.containerPadding * 2),
                    Text("01:00",
                        style: TextStyle(color: ThemeColors.colorWhite)),
                    Expanded(
                      child: Slider(
                        value: this._sliderValue,
                        onChanged: (data) {
                          setState(() {
                            this._sliderValue = data;
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
                    Text("03:38",
                        style: TextStyle(color: ThemeColors.colorWhite)),
                    SizedBox(width: ThemeSize.containerPadding * 2),
                  ],
                ),
                SizedBox(height: ThemeSize.containerPadding * 2),
                Row(
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
                            Container(
                              width: ThemeSize.bigAvater,
                              height: ThemeSize.bigAvater,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(ThemeSize.bigAvater),
                                border: Border.all(
                                    color: ThemeColors.colorWhite, width: 2),
                              ),
                              child: Center(
                                  child: Image.asset(
                                    Provider.of<PlayerMusicProvider>(context).playing ? "lib/assets/images/icon-music-playing.png" : "lib/assets/images/icon-music-play-white.png",
                                width: ThemeSize.playIcon,
                                height: ThemeSize.playIcon,
                              )),
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
                )
              ],
            ),
          )
        ]));
  }
}
