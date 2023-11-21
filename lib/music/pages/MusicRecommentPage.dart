import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:audioplayers/audioplayers.dart';
import '../model/MusicModel.dart';
import 'package:provider/provider.dart';
import '../provider/PlayerMusicProvider.dart';
import '../pages/MusicPlayerPage.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../../config/common.dart';

class MusicRecommentPage extends StatefulWidget {
  MusicRecommentPage({Key key}) : super(key: key);

  @override
  _MusicRecommentPageState createState() => _MusicRecommentPageState();
}

class _MusicRecommentPageState extends State<MusicRecommentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int pageNum = 2; // 初始化加载两页共20条数据，后面每页加载10条
  int pageSize = 10;
  int total = 0;
  List<MusicModel> musicModelList = [];
  List<String> iconList = [
    "lib/assets/images/icon-no1.png",
    "lib/assets/images/icon-no2.png",
    "lib/assets/images/icon-no3.png"
  ];
  MusicModel currentPlayingMusicModel;
  bool playing;

  @override
  void initState() {
    super.initState();
    getRecommendMusicList(1, 20);
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

  void getRecommendMusicList(int pageNum, pageSize) {
    getMusicListByClassifyIdService(1, pageNum, pageSize, 0).then((res) {
      setState(() {
        total = res["total"];
        (res["data"] as List).cast().forEach((item) {
          item['classifyId'] = 1;
          item['pageNum'] = pageNum;
          item['pageSize'] = pageSize;
          item['isRedis'] = 0;
          musicModelList.add(MusicModel.fromJson(item));
        });
      });
    });
  }

  // 创建音乐列表项
  Widget buildMusicItem(
      List<MusicModel> musicModelList, MusicModel musicModel, int index) {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: Row(children: [
          index < iconList.length
              ? Image.asset(iconList[index],
                  width: ThemeSize.middleIcon, height: ThemeSize.middleIcon)
              : Container(
                  width: ThemeSize.middleIcon,
                  height: ThemeSize.middleIcon,
                  child: Center(
                      child: Text(
                    (index + 1).toString(),
                  ))),
          SizedBox(width: ThemeSize.containerPadding),
          ClipOval(
              child: Image.network(
            //从全局的provider中获取用户信息
            HOST + musicModel.cover,
            height: ThemeSize.middleAvater,
            width: ThemeSize.middleAvater,
            fit: BoxFit.cover,
          )),
          SizedBox(width: ThemeSize.containerPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(musicModel.songName,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: ThemeSize.smallMargin),
                Text(musicModel.authorName,
                    style: TextStyle(color: ThemeColors.disableColor)),
              ],
            ),
            flex: 1,
          ),
          InkWell(
              child: Image.asset(
                  playing && musicModel.id == currentPlayingMusicModel.id
                      ? "lib/assets/images/icon-music-playing-grey.png"
                      : "lib/assets/images/icon-music-play.png",
                  width: ThemeSize.smallIcon,
                  height: ThemeSize.smallIcon),
              onTap: () {
                Provider.of<PlayerMusicProvider>(context, listen: false)
                    .setPlayMusic(musicModelList, musicModel, index, true);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MusicPlayerPage()));
              }),
          SizedBox(width: ThemeSize.containerPadding),
          Image.asset(
              "lib/assets/images/icon-like${musicModel.isLike == 1 ? "-active" : ""}.png",
              width: ThemeSize.smallIcon,
              height: ThemeSize.smallIcon),
          SizedBox(width: ThemeSize.containerPadding),
          Image.asset("lib/assets/images/icon-music-menu.png",
              width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
        ]));
  }

  List<Widget> buildMusicWedgetList() {
    List<Widget> musicWedgetList = [];
    int index = 0;
    musicModelList.forEach((element) {
      musicWedgetList.add(buildMusicItem(musicModelList, element, index));
      index++;
    });
    return musicWedgetList;
  }

  @override
  Widget build(BuildContext context) {
    currentPlayingMusicModel =
        Provider.of<PlayerMusicProvider>(context).musicModel;
    playing = Provider.of<PlayerMusicProvider>(context).playing;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: EasyRefresh(
        footer: MaterialFooter(),
        onLoad: () async {
          pageNum++;
          if (total <= musicModelList.length) {
            Fluttertoast.showToast(
                msg: "已经到底了",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: ThemeSize.middleFontSize);
          } else {
            getRecommendMusicList(pageNum, pageSize);
          }
        },
        child: Column(
          children: buildMusicWedgetList(),
        ),
      ),
    );
  }
}
