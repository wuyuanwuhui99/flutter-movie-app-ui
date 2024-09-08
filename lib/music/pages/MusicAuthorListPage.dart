import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import '../model/MusicAuthorModel.dart';
import '../component/MusicListComponent.dart';
import '../model/MusicModel.dart';
import '../provider/PlayerMusicProvider.dart';
import '../../router/index.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeColors.dart';
import '../../common/constant.dart';
import '../component/NavigatorTitleComponent.dart';

class MusicAuthorListPage extends StatefulWidget {
  final MusicAuthorModel authorMode;
  MusicAuthorListPage({Key key,this.authorMode}) : super(key: key);

  @override
  _MusicAuthorListPageState createState() => _MusicAuthorListPageState();
}

class _MusicAuthorListPageState extends State<MusicAuthorListPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  int activeIndex = 0; // 当前选中的分类
  int pageNum = 1; // 总页数
  int total = 0; // 总条数
  int pageSize = 20; // 每页条数
  List<MusicModel> musicList = [];
  EasyRefreshController easyRefreshController = EasyRefreshController();
  PlayerMusicProvider provider;

  @override
  void initState() {
    super.initState();
    useMusicList();
  }

  ///@author: wuwenqiang
  ///@description: 根据分类获取列表
  ///@date: 2024-02-28 22:20
  useMusicList() {
    getMusicListByAuthorIdService(widget.authorMode.authorId, pageNum, pageSize)
        .then((value) {
      setState(() {
        total = value.total;
        value.data.forEach((item) {
          musicList.add(MusicModel.fromJson(item));
        });
      });
      easyRefreshController.finishLoad(success: true,noMore: musicList.length == total);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                  NavigatorTitleComponent(title: widget.authorMode.authorName),
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
                            if (pageNum * pageSize < total) {
                              useMusicList();
                            }
                        },
                        child: Padding(
                          padding: ThemeStyle.padding,
                          child: MusicListComponent(musicList: musicList,classifyName: MUSIC_SEARCH_NAME ,onPlayMusic:(MusicModel musicModel,int index){
                            usePlayRouter(musicModel,index);
                          }),
                        ),
                      )),
                ],
              ),
            ),
        ));
  }

  ///@author: wuwenqiang
  ///@description: 播放音乐
  ///@date: 2024-08-24 11:53
  void usePlayRouter(MusicModel musicItem,int index){
    if(musicItem.id != provider.musicModel?.id){
      provider.insertMusic(musicItem, provider.playIndex);
    }
    Routes.router.navigateTo(context, '/MusicPlayerPage');
  }
}
