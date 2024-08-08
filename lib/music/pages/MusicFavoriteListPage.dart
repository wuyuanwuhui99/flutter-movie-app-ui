import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../component/MusicListComponent.dart';
import '../../router/index.dart';
import '../../common/constant.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/FavoriteDirectoryModel.dart';
import '../service/serverMethod.dart';
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
  PlayerMusicProvider provider;
  EasyRefreshController easyRefreshController = EasyRefreshController();

  @override
  void initState() {
    // 获取当前播放的歌曲，不能设置listen: true，否则会抛出
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
      easyRefreshController.finishLoad(success: true,noMore: musicList.length == total);
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PlayerMusicProvider>(context, listen: true);
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
                      controller: easyRefreshController,
                      footer: ClassicalFooter(
                        loadText: '上拉加载',
                        loadReadyText: '准备加载',
                        loadingText: '加载中...',
                        loadedText: '加载完成',
                        noMoreText: '没有更多',
                        bgColor: Colors.transparent,
                        textColor: ThemeColors.disableColor,
                      ),
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
                            MusicListComponent(musicList: musicList,classifyName: MUSIC_FAVORITE_NAME + widget.favoriteDirectoryModel.name,onPlayMusic:(MusicModel musicModel,int index){
                              usePlayRouter(musicModel,index);
                            })
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
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.favoriteDirectoryModel.name),
                    SizedBox(height: ThemeSize.containerPadding),
                    Text(
                      '${widget.favoriteDirectoryModel.total.toString()}首',
                      style: TextStyle(color: ThemeColors.disableColor),
                    )
                  ])),
          InkWell(
            child: Image.asset("lib/assets/images/icon_edit.png",
                width: ThemeSize.middleIcon, height: ThemeSize.middleIcon),
          )
        ],
      ),
    );
  }

  ///@author: wuwenqiang
  ///@description: 播放音乐列表
  /// @date: 2024-07-20 04:13
  usePlayRouter(MusicModel musicModel,int index)async{
    PlayerMusicProvider provider = Provider.of<PlayerMusicProvider>(context, listen: false);
    String classifyName = MUSIC_FAVORITE_NAME + widget.favoriteDirectoryModel.name;
    if(provider.classifyName != classifyName){
      await getMusicListByFavoriteIdService(widget.favoriteDirectoryModel.id, 1, MAX_FAVORITE_NUMBER).then((value) {
        provider.setClassifyMusic(value.data.map((e) => MusicModel.fromJson(e)).toList(),index,classifyName);
      });
    }else{
      provider.setPlayMusic(musicModel, true);
    }
    Routes.router.navigateTo(context, '/MusicPlayerPage');
  }
}
