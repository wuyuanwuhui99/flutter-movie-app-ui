import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../model/MusicModel.dart';
import '../model/MusicClassifyModel.dart';
import '../model/MusicAuthorModel.dart';
import '../provider/PlayerMusicProvider.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../config/serviceUrl.dart';
import './MusicSearchPage.dart';
import '../utils/LocalStroageUtils.dart';
import './MusicPlayerPage.dart';

class MusicHomePage extends StatefulWidget {
  MusicHomePage({Key key}) : super(key: key);

  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int pageNum = 1;
  List<MusicClassifyModel> currentClassifiesList = [];
  List<MusicClassifyModel> allClassifies = [];
  bool playing = false;
  MusicModel currentPlayingMusicModel;

  @override
  void initState() {
    super.initState();
    getMusicClassifyService().then((res) {
      allClassifies = (res["data"] as List).cast().map((item) {
        return MusicClassifyModel.fromJson(item);
      }).toList();
      setState(() {
        currentClassifiesList.addAll(allClassifies.sublist(0, 4));
      });
    });
  }

  void _getCategoryItem() {
    if (pageNum < allClassifies.length) {
      setState(() {
        currentClassifiesList.add(allClassifies[pageNum]);
      });
    }
  }

  List<Widget> buildCurrentClassifiesWidget() {
    List<Widget> currentClassifiesWidget = [];
    currentClassifiesList.forEach((element) {
      currentClassifiesWidget.add(buildMuiscModuleByClassifyIdWidget(element));
    });
    return currentClassifiesWidget;
  }

  @override
  Widget build(BuildContext context) {
    currentPlayingMusicModel =
        Provider.of<PlayerMusicProvider>(context).musicModel;
    playing = Provider.of<PlayerMusicProvider>(context).playing;
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: ThemeStyle.paddingBox,
        child: Column(children: <Widget>[
          buildSearchWidget(),
          Expanded(
              flex: 1,
              child: EasyRefresh(
                footer: MaterialFooter(),
                onLoad: () async {
                  pageNum++;
                  if (pageNum >= allClassifies.length) {
                    Fluttertoast.showToast(
                        msg: "已经到底了",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: ThemeSize.middleFontSize);
                  } else {
                    _getCategoryItem();
                  }
                },
                child: Column(
                  children: [
                    buildClassifyWidget(),
                    ...buildCurrentClassifiesWidget()
                  ],
                ),
              ))
        ]));
  }

  Widget buildSearchWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.network(
                //从全局的provider中获取用户信息
                host + Provider.of<UserInfoProvider>(context).userInfo.avater,
                height: ThemeSize.middleAvater,
                width: ThemeSize.middleAvater,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.only(left: ThemeSize.smallMargin),
                    child: FutureBuilder(
                        future: getKeyWordMusicService(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          var result = snapshot.data;
                          String keyword = "";
                          if (result != null && result['data'] != null) {
                            MusicModel musicModel =
                                MusicModel.fromJson(result["data"]);
                            PlayerMusicProvider musicProvider =
                                Provider.of<PlayerMusicProvider>(context);
                            if (musicProvider.musicModel == null) {
                              // 如果缓存中没有正在播放的歌曲，用推荐的歌曲作为正在播放的歌曲
                              musicProvider
                                  .setPlayMusic([], musicModel, 0, false);
                              LocalStroageUtils.setPlayMusic(musicModel);
                            }
                            keyword =
                                '${musicModel.authorName} - ${musicModel.songName}';
                          }
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MusicSearchPage(keyword: keyword)));
                              },
                              child: Container(
                                  height: ThemeSize.buttonHeight,
                                  //修饰黑色背景与圆角
                                  decoration: new BoxDecoration(
                                    color: ThemeColors.colorBg,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(
                                            ThemeSize.bigRadius)),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left: ThemeSize.containerPadding),
                                  child: Text(
                                    keyword,
                                    style: TextStyle(color: Colors.grey),
                                  )));
                        })))
          ],
        ));
  }

  Widget buildClassifyWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("lib/assets/images/icon-music-singer.png",
                    width: ThemeSize.bigAvater, height: ThemeSize.bigAvater),
                SizedBox(height: ThemeSize.smallMargin),
                Text("歌手")
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("lib/assets/images/icon-music-classify.png",
                    width: ThemeSize.bigAvater, height: ThemeSize.bigAvater),
                SizedBox(height: ThemeSize.smallMargin),
                Text("分类歌曲")
              ],
            ),
            flex: 1,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("lib/assets/images/icon-music-rank.png",
                  width: ThemeSize.bigAvater, height: ThemeSize.bigAvater),
              SizedBox(height: ThemeSize.smallMargin),
              Text("排行榜")
            ],
          )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("lib/assets/images/icon-music-classics.png",
                    width: ThemeSize.bigAvater, height: ThemeSize.bigAvater),
                SizedBox(height: ThemeSize.smallMargin),
                Text("经典老哥")
              ],
            ),
            flex: 1,
          )
        ]));
  }

  // 获取分类音乐
  Widget buildMuiscModuleByClassifyIdWidget(
      MusicClassifyModel musicClassifyModel) {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("lib/assets/images/icon-down.png",
                    width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
                SizedBox(width: ThemeSize.smallMargin),
                Text(musicClassifyModel.classifyName),
                Expanded(child: SizedBox(), flex: 1),
                Text("更多")
              ],
            ),
            musicClassifyModel.classifyName == "推荐歌手"
                ? buildSingerListWidget()
                : buildMusicListByClassifyId(musicClassifyModel.id)
          ],
        ));
  }

  // 获取音乐列表
  Widget buildMusicListByClassifyId(int classifyId) {
    return FutureBuilder(
        future: getMusicListByClassifyIdService(classifyId, 1, 3, 1),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List<MusicModel> musicModelList = [];
            List<Widget> musicWidgetList = [];
            int index = 0;
            (snapshot.data["data"] as List).cast().forEach((element) {
              element['classifyId'] = classifyId;
              element['classifyId'] = 1;
              element['classifyId'] = 3;
              element['isRedis'] = 1;
              MusicModel musicItem = MusicModel.fromJson(element);
              musicModelList.add(musicItem);
              musicWidgetList.add(Padding(
                  padding: EdgeInsets.only(
                    top: ThemeSize.containerPadding,
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          //从全局的provider中获取用户信息
                          host + musicItem.cover,
                          height: ThemeSize.bigAvater,
                          width: ThemeSize.bigAvater,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: ThemeSize.containerPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(musicItem.songName,
                                style:
                                    TextStyle(fontSize: ThemeSize.bigFontSize)),
                            SizedBox(height: ThemeSize.smallMargin),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: ThemeSize.miniMargin,
                                      right: ThemeSize.miniMargin),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ThemeSize.minBtnRadius)),
                                      border: Border.all(
                                          width: 1,
                                          color: ThemeColors.activeColor)),
                                  child: Text("Hi-Res",
                                      style: TextStyle(
                                          color: ThemeColors.activeColor)),
                                ),
                                SizedBox(width: ThemeSize.smallMargin),
                                Expanded(
                                  child: Text(
                                    "${musicItem.authorName} - ${musicItem.albumName}",
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ThemeColors.disableColor),
                                  ),
                                  flex: 1,
                                )
                              ],
                            )
                          ],
                        ),
                        flex: 1,
                      ),
                      InkWell(
                          child: Image.asset(
                            playing &&
                                    musicItem.id == currentPlayingMusicModel.id
                                ? "lib/assets/images/icon-music-playing-grey.png"
                                : "lib/assets/images/icon-music-play.png",
                            width: ThemeSize.smallIcon,
                            height: ThemeSize.smallIcon,
                          ),
                          onTap: () {
                            Provider.of<PlayerMusicProvider>(context,
                                    listen: false)
                                .setPlayMusic(
                                    musicModelList, musicItem, index, true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusicPlayerPage()));
                          }),
                      SizedBox(width: ThemeSize.containerPadding),
                      Image.asset(
                        "lib/assets/images/icon-music-add.png",
                        width: ThemeSize.smallIcon,
                        height: ThemeSize.smallIcon,
                      ),
                      SizedBox(width: ThemeSize.containerPadding),
                      Image.asset(
                        "lib/assets/images/icon-music-menu.png",
                        width: ThemeSize.smallIcon,
                        height: ThemeSize.smallIcon,
                      )
                    ],
                  )));
              index++;
            });
            return Column(children: musicWidgetList);
          }
        });
  }

  // 获取歌手列表
  Widget buildSingerListWidget() {
    return FutureBuilder(
        future: getSingerListService(1, 5),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List authorsList = snapshot.data["data"] as List;
            // 动态计算歌手头像大小
            double size = (MediaQuery.of(context).size.width -
                    (authorsList.length + 3) * ThemeSize.containerPadding) /
                authorsList.length;
            return Column(
              children: [
                SizedBox(height: ThemeSize.containerPadding),
                Row(
                    children: authorsList.cast().map((item) {
                  MusicAuthorModel authorModel =
                      MusicAuthorModel.fromJson(item);
                  return Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              //从全局的provider中获取用户信息
                              authorModel.avatar.indexOf("http") != -1
                                  ? authorModel.avatar
                                      .replaceAll("{size}", "480")
                                  : host + authorModel.avatar,
                              height: size,
                              width: size,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: ThemeSize.containerPadding),
                          Text(authorModel.authorName)
                        ],
                      ));
                }).toList())
              ],
            );
          }
        });
  }
}
