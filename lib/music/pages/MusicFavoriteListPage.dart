import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:movie/music/provider/PlayerMusicProvider.dart';
import 'package:provider/provider.dart';
import '../model/FavoriteDirectoryModel.dart';
import '../service/serverMethod.dart';
import 'dart:ui';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../model/MusicModel.dart';
import '../../utils/common.dart';

class MusicFavoriteListPage extends StatefulWidget {
  final FavoriteDirectoryModel favoriteDirectoryModel;

  MusicFavoriteListPage({Key key, this.favoriteDirectoryModel})
      : super(key: key);

  @override
  _MusicFavoriteListPageState createState() => _MusicFavoriteListPageState();
}

class _MusicFavoriteListPageState extends State<MusicFavoriteListPage>
    with TickerProviderStateMixin, RouteAware {
  List<MusicModel> musicList = [];
  bool loading = false;
  int pageNum = 1;
  int total = 0;
  final int pageSize = 20;

  @override
  void initState() {
    useMusicListByFavoriteId();
    super.initState();
  }

  ///@author: wuwenqiang
  ///@description: 获取音乐列表
  /// @date: 2024-07-20 00:27
  useMusicListByFavoriteId() {
    getMusicListByFavoriteIdService(
            widget.favoriteDirectoryModel.id, pageNum, pageSize)
        .then((value) {
      setState(() {
        total = value.total;
        musicList
            .addAll(value.data.map((e) => MusicModel.fromJson(e)).toList());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                buildTitleWidget(),
                Expanded(
                    flex: 1,
                    child: EasyRefresh(
                      footer: MaterialFooter(),
                      onLoad: () async {
                        if (total > pageNum * pageSize) {
                          pageNum++;
                          useMusicListByFavoriteId();
                        }
                      },
                      child: Padding(
                        padding: ThemeStyle.padding,
                        child: Column(
                          children: [
                            buildCoverWidget(),
                            SizedBox(height: ThemeSize.containerPadding),
                            buildMusicListWidget()
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  ///@author: wuwenqiang
  ///@description: 创建标题栏
  /// @date: 2024-07-13 17:33
  Widget buildTitleWidget() {
    return Container(
        padding: ThemeStyle.padding,
        decoration: BoxDecoration(color: ThemeColors.colorWhite),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset("lib/assets/images/icon_back.png",
                width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
          ),
          Expanded(flex: 1, child: Center(child: Text("我的收藏夹"))),
          SizedBox(
            width: ThemeSize.smallIcon,
            height: ThemeSize.smallIcon,
          ),
        ]));
  }

  ///@author: wuwenqiang
  ///@description: 创建头部按钮
  /// @date: 2024-07-13 17:33
  Widget buildCoverWidget() {
    return Container(
      padding: ThemeStyle.padding,
      decoration: ThemeStyle.boxDecoration,
      child: Row(
        children: [
          ClipRRect(
              child: Image.network(
                getMusicCover(widget.favoriteDirectoryModel.cover),
                width: ThemeSize.bigAvater,
                height: ThemeSize.bigAvater,
              ),
              borderRadius: BorderRadius.circular(ThemeSize.middleRadius)),
          SizedBox(width: ThemeSize.containerPadding),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.favoriteDirectoryModel.name),
            SizedBox(height: ThemeSize.containerPadding),
            Text(
              '${widget.favoriteDirectoryModel.total.toString()}首',
              style: TextStyle(color: ThemeColors.disableColor),
            )
          ])
        ],
      ),
    );
  }

  void useLike(MusicModel musicModel){
    if(musicModel.isLike == 0){
      insertMusicLikeService(musicModel.id).then((res) => {
        if(res.data > 0){
          setState(() {
            musicModel.isLike = 1;
          })
        }
      });
    }else{
      deleteMusicLikeService(musicModel.id).then((res) => {
        if(res.data > 0){
          setState(() {
            musicModel.isLike = 0;
          })
        }
      });
    }
  }

  ///@author: wuwenqiang
  ///@description: 创建收藏音乐列表
  /// @date: 2024-07-20 00:24
  Widget buildMusicListWidget() {
    int index = -1;
    PlayerMusicProvider provider =
        Provider.of<PlayerMusicProvider>(context, listen: false);
    return Container(
      padding: ThemeStyle.padding,
      decoration: ThemeStyle.boxDecoration,
      child: Column(
          children: musicList.map((musicModel) {
        index++;
        return Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    //从全局的provider中获取用户信息
                    getMusicCover(musicModel.cover),
                    height: ThemeSize.middleAvater,
                    width: ThemeSize.middleAvater,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: ThemeSize.containerPadding),
                Expanded(
                    flex: 1,
                    child: Text(
                        '${musicModel.authorName} - ${musicModel.songName}')),
                SizedBox(width: ThemeSize.containerPadding),
                Image.asset(
                    provider.playing && provider.musicModel?.id == musicModel.id
                        ? 'lib/assets/images/icon_music_playing_grey.png'
                        : 'lib/assets/images/icon_music_play.png',
                    width: ThemeSize.smallIcon,
                    height: ThemeSize.smallIcon),
                SizedBox(width: ThemeSize.containerPadding),
                InkWell(child: Image.asset(
                    "lib/assets/images/icon_like${musicModel.isLike == 1 ? "_active" : ""}.png",
                    width: ThemeSize.smallIcon,
                    height: ThemeSize.smallIcon),onTap: (){
                  useLike(musicModel);
                }),
                SizedBox(width: ThemeSize.containerPadding),
                Image.asset('lib/assets/images/icon_music_menu.png',
                    width: ThemeSize.smallIcon, height: ThemeSize.smallIcon)
              ],
            ),
            SizedBox(
                height: index != musicList.length - 1
                    ? ThemeSize.containerPadding
                    : 0),
            index != musicList.length - 1
                ? Divider(height: 1, color: ThemeColors.borderColor)
                : SizedBox(),
          ],
        );
      }).toList()),
    );
  }
}
