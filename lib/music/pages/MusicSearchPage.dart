import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../model/MusicModel.dart';
import "package:shared_preferences/shared_preferences.dart";
import '../../movie/component/TitleComponent.dart';
import '../service/serverMethod.dart';
import '../../config/common.dart';
import 'package:provider/provider.dart';
import '../provider/PlayerMusicProvider.dart';
import 'package:movie/router/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicSearchPage extends StatefulWidget {
  final String keyword;

  MusicSearchPage({Key key, this.keyword}) : super(key: key);

  @override
  _SearchMusicPageState createState() => _SearchMusicPageState();
}

class _SearchMusicPageState extends State<MusicSearchPage> {
  bool searching = false;
  bool loading = false;
  bool showClearIcon = false;
  int pageNum = 1;
  int pageSize = 20;
  int total = 0;
  List<MusicModel> searchResult = [];
  List<Widget> myHistoryLabels = [];
  List<String> myHistoryLabelsName = [];
  TextEditingController keywordController = TextEditingController();
  MusicModel currentPlayingMusicModel;
  bool playing = false;
  EasyRefreshController easyRefreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    getHistory();
    usePlayState();
  }

  /// 获取播放状态
  usePlayState() {
    AudioPlayer player =
        Provider.of<PlayerMusicProvider>(context, listen: false).player;
    player.onPlayerStateChanged.listen((event) {
      setState(() {
        playing = event.index == 1;
      });
    });
  }

  getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String historyLabels = prefs.getString('historyMusicLabels');
    if (historyLabels != null && historyLabels != '') {
      setState(() {
        myHistoryLabelsName = historyLabels.split(",");
        int length =
            myHistoryLabelsName.length <= 20 ? myHistoryLabelsName.length : 20;
        for (int i = 0; i < length; i++) {
          myHistoryLabels.add(Label(myHistoryLabelsName[i]));
        }
      });
    }
  }

  ///@author: wuwenqiang
  ///@description: 搜索
  /// @date: 2024-01-27 16:46
  goSearch() {
    searchMusicService(
            Uri.encodeComponent(keywordController.text), pageNum, pageSize)
        .then((res) {
      setState(() {
        loading = false;
        total = res.total;
        res.data.forEach((item) {
          searchResult.add(MusicModel.fromJson(item));
        }); // 顶部轮播组件数
      });
    }).catchError(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    currentPlayingMusicModel =
        Provider.of<PlayerMusicProvider>(context).musicModel;
    playing = Provider.of<PlayerMusicProvider>(context).playing;
    return Scaffold(
      backgroundColor: ThemeColors.colorBg,
      body: SafeArea(
        top: true,
        child: Container(
            padding: ThemeStyle.paddingBox,
            child: EasyRefresh(
              controller: easyRefreshController,
              footer: total > searchResult.length ? MaterialFooter() : null,
              onLoad: () async {
                if (total > searchResult.length) {
                  pageNum++;
                  goSearch();
                } else {
                  // easyRefreshController
                  Fluttertoast.showToast(
                      msg: "已经到底了",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: ThemeSize.middleFontSize);
                }
              },
              child: Column(
                children: [
                  buildSearchInputWidget(),
                  this.searching
                      ? (this.loading ? SizedBox() : buildMusicListWidget())
                      : Column(
                          children: [buildHistorySearchWidget()],
                        )
                ],
              ),
            )),
      ),
    );
  }

  Widget buildSearchInputWidget() {
    return Container(
      decoration: ThemeStyle.boxDecoration,
      padding: ThemeStyle.padding,
      margin: ThemeStyle.margin,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  height: ThemeSize.buttonHeight,
                  //修饰黑色背景与圆角
                  decoration: new BoxDecoration(
                    color: ThemeColors.colorBg,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(ThemeSize.superRadius)),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: ThemeSize.smallMargin * 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: TextField(
                              controller: keywordController,
                              cursorColor: Colors.grey, //设置光标
                              decoration: InputDecoration(
                                hintText: widget.keyword,
                                hintStyle: TextStyle(
                                    fontSize: ThemeSize.smallFontSize,
                                    color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    bottom: ThemeSize.smallMargin),
                              ))),
                      showClearIcon
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  keywordController.text = ""; //清除输入框的值
                                  searching = false;
                                  showClearIcon = false;
                                });
                              },
                              child: Image.asset(
                                "lib/assets/images/icon_clear.png",
                                height: ThemeSize.smallIcon,
                                width: ThemeSize.smallIcon,
                              ))
                          : SizedBox(),
                      SizedBox(width: ThemeSize.smallMargin)
                    ],
                  )),
              flex: 1),
          SizedBox(width: ThemeSize.smallMargin),
          Container(
              height: ThemeSize.buttonHeight,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  if (this.loading) return;
                  if (keywordController.text == "")
                    keywordController.text = widget.keyword;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int index =
                      myHistoryLabelsName.indexOf(keywordController.text);
                  if (index != -1) {
                    myHistoryLabelsName.removeAt(index);
                    myHistoryLabelsName.insert(0, keywordController.text);
                  } else {
                    myHistoryLabelsName.add(keywordController.text);
                  }
                  prefs.setString(
                      "historyMusicLabels", myHistoryLabelsName.join(","));
                  setState(() {
                    pageNum = 1;
                    showClearIcon = true;
                    myHistoryLabels.insert(0, Label(keywordController.text));
                    this.searching = this.loading = true;
                    searchResult = [];
                  });
                  goSearch();
                },
                child: Text(
                  '搜索',
                  style: TextStyle(
                      fontSize: ThemeSize.middleFontSize, color: Colors.white),
                ),

                ///圆角
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(ThemeSize.bigRadius))),
              ))
        ],
      ),
    );
  }

  Widget Label(String text) {
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      color: Color.fromARGB(255, 230, 230, 230),
      onPressed: () {
        setState(() {
          keywordController.text = text;
          loading = searching = true;
          showClearIcon = true;
          searchResult = [];
        });
        goSearch();
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.grey),
      ),

      ///圆角
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50))),
    );
  }

  Widget buildHistorySearchWidget() {
    return Container(
      decoration: ThemeStyle.boxDecoration,
      padding: ThemeStyle.padding,
      margin: ThemeStyle.margin,
      alignment: Alignment.centerLeft,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleComponent(title: "历史搜索"),
            myHistoryLabels.length > 0
                ? Wrap(
                    spacing: ThemeSize.smallMargin,
                    children: myHistoryLabels,
                  )
                : Container(
                    height: 80,
                    child: Text("暂无搜索记录"),
                    alignment: Alignment.center,
                  )
          ]),
    );
  }

  Widget buildMusicListWidget() {
    int index = -1;
    return Container(
        decoration: ThemeStyle.boxDecoration,
        padding: ThemeStyle.padding,
        margin: ThemeStyle.margin,
        child: searchResult.length > 0
            ? Column(
                children: searchResult.map((musicItem) {
                index++;
                return Container(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 0 : ThemeSize.smallMargin,
                        bottom:  index == searchResult.length ? 0 :ThemeSize.smallMargin),
                    decoration: index == searchResult.length ? null : BoxDecoration(border: Border(
                      bottom: BorderSide(
                        color: ThemeColors.colorBg, // 边框颜色
                        width: 1, // 边框宽度
                      ),
                    )),
                    child: Row(children: [
                      ClipOval(
                          child: Image.network(
                            //从全局的provider中获取用户信息
                            HOST + musicItem.cover,
                            height: ThemeSize.middleAvater,
                            width: ThemeSize.middleAvater,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(width: ThemeSize.containerPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(musicItem.songName,
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: ThemeSize.smallMargin),
                            Text(musicItem.authorName,
                                style:
                                TextStyle(color: ThemeColors.disableColor)),
                          ],
                        ),
                        flex: 1,
                      ),
                      InkWell(
                          child: Image.asset(
                              playing &&
                                  musicItem.id ==
                                      currentPlayingMusicModel.id
                                  ? "lib/assets/images/icon_music_playing_grey.png"
                                  : "lib/assets/images/icon_music_play.png",
                              width: ThemeSize.smallIcon,
                              height: ThemeSize.smallIcon),
                          onTap: () {
                            Provider.of<PlayerMusicProvider>(context,
                                listen: false)
                                .setPlayMusic(
                                searchResult, musicItem, index, true);
                            Routes.router
                                .navigateTo(context, '/MusicPlayerPage');
                          }),
                      SizedBox(width: ThemeSize.containerPadding),
                      InkWell(child: Image.asset(
                          "lib/assets/images/icon_like${musicItem.isLike == 1 ? "_active" : ""}.png",
                          width: ThemeSize.smallIcon,
                          height: ThemeSize.smallIcon),onTap: (){
                        if(musicItem.isLike == 0){
                          insertMusicLikeService(musicItem.id).then((res) => {
                            if(res.data > 0){
                              setState(() {
                                musicItem.isLike = 1;
                              })
                            }
                          });
                        }else{
                          deleteMusicLikeService(musicItem.id).then((res) => {
                            if(res.data > 0){
                              setState(() {
                                musicItem.isLike = 0;
                              })
                            }
                          });
                        }
                      }),
                      SizedBox(width: ThemeSize.containerPadding),
                      Image.asset("lib/assets/images/icon_music_menu.png",
                          width: ThemeSize.smallIcon,
                          height: ThemeSize.smallIcon),
                    ]));
              }).toList())
            : Text("暂无数据"));
  }
}
