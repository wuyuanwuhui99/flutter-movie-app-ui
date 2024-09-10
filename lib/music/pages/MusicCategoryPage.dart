import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import '../component/MusicListComponent.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/MusicClassifyModel.dart';
import '../model/MusicModel.dart';
import '../../router/index.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../../common/constant.dart';
import '../component/NavigatorTitleComponent.dart';

class MusicCategoryPage extends StatefulWidget {
  MusicCategoryPage({Key key}) : super(key: key);

  @override
  _MusicCategoryPageState createState() => _MusicCategoryPageState();
}

class _MusicCategoryPageState extends State<MusicCategoryPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  int activeIndex = 0; // 当前选中的分类
  int pageNum = 1; // 总页数
  int total = 0; // 总条数
  List<MusicModel> musicList = [];
  EasyRefreshController easyRefreshController = EasyRefreshController();
  List<MusicClassifyModel> allClassifies = [];
  List<MusicClassifyModel> currentClassify = [];
  bool expand = false;

  @override
  void initState() {
    super.initState();
    getMusicClassifyService().then((res) {
      setState(() {
        allClassifies = res.data.map((item) {
          return MusicClassifyModel.fromJson(item);
        }).toList();
        currentClassify = allClassifies.sublist(0, 9);
      });
      useMusicListByClassifyId();
    });
  }

  ///@author: wuwenqiang
  ///@description: 根据分类获取列表
  ///@date: 2024-09-10 22:03
  useMusicListByClassifyId() {
    getMusicListByClassifyIdService(
            allClassifies[activeIndex].id, pageNum, PAGE_SIZE, 1)
        .then((value) {
      setState(() {
        total = value.total;
        value.data.forEach((element) {
          musicList.add(MusicModel.fromJson(element));
        });
        easyRefreshController.finishLoad(
            success: true, noMore: musicList.length == total);
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
                NavigatorTitleComponent(title: '歌曲分类'),
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
                        if (pageNum * PAGE_SIZE < total) {
                          useMusicListByClassifyId();
                        }
                      },
                      child: Padding(
                        padding: ThemeStyle.padding,
                        child: Column(
                          children: [
                            buildCategory(),
                            musicList.length > 0
                                ? MusicListComponent(
                                    musicList: musicList,
                                    classifyName:
                                        MUSIC_CLASSIFY_NAME_STORAGE_KEY +
                                            allClassifies[activeIndex]
                                                .classifyName,
                                    onPlayMusic:
                                        (MusicModel musicModel, int index) {
                                      usePlayRouter(musicModel, index);
                                    })
                                : SizedBox()
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
  ///@description: 播放音乐列表
  /// @date: 2024-09-10 22:10
  usePlayRouter(MusicModel musicModel, int index) async {
    PlayerMusicProvider provider =
        Provider.of<PlayerMusicProvider>(context, listen: false);
    if (provider.classifyName !=
        MUSIC_CLASSIFY_NAME_STORAGE_KEY +
            allClassifies[activeIndex].classifyName) {
      await getMusicListByClassifyIdService(
              allClassifies[activeIndex].id, 1, MAX_FAVORITE_NUMBER, 1)
          .then((value) {
        provider.setClassifyMusic(
            value.data.map((e) => MusicModel.fromJson(e)).toList(),
            index,
            MUSIC_CLASSIFY_NAME_STORAGE_KEY +
                allClassifies[activeIndex].classifyName);
      });
    } else {
      provider.setPlayMusic(musicModel, true);
    }
    Routes.router.navigateTo(context, '/MusicPlayerPage');
  }

  ///@author: wuwenqiang
  ///@description: 歌手分类
  ///@date: 2024-02-28 22:20
  Widget buildCategory() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width: double.infinity,
        padding: ThemeStyle.padding,
        child: Column(
          children: [
            GridView.count(
                mainAxisSpacing: ThemeSize.smallMargin,
                //水平子 Widget 之间间距
                crossAxisSpacing: ThemeSize.smallMargin,
                //一行的 Widget 数量
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 3,
                // 宽高比列
                children: this.buildGridItems(context)),
            SizedBox(height: ThemeSize.containerPadding),
            InkWell(
              onTap: () {
                setState(() {
                  expand = !expand;
                  currentClassify = allClassifies.sublist(
                      0, expand ? allClassifies.length : 9);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(expand ? '收起' : '展开更多'),
                  SizedBox(width: ThemeSize.smallMargin),
                  Transform.rotate(
                      angle: (expand ? 90 : 0) * pi / 180,
                      child: Image.asset("lib/assets/images/icon_arrow.png",
                          height: ThemeSize.smallIcon,
                          width: ThemeSize.smallIcon,
                          fit: BoxFit.cover)),
                ],
              ),
            )
          ],
        ));
  }

  List<Widget> buildGridItems(BuildContext context) {
    List<Widget> musicCategoryWidgetList = [];
    for (int i = 0; i < currentClassify.length; i++) {
      musicCategoryWidgetList.add(InkWell(
          onTap: () {
            setState(() {
              total = 0;
              pageNum = 1;
              activeIndex = i;
              musicList.clear();
              useMusicListByClassifyId();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: allClassifies[activeIndex].id == allClassifies[i].id
                      ? Colors.orange
                      : ThemeColors.borderColor),
              borderRadius:
                  BorderRadius.all(Radius.circular(ThemeSize.middleRadius)),
            ),
            child: Center(
                child: Text(
              allClassifies[i].classifyName,
              style: TextStyle(
                  color: allClassifies[activeIndex].id == allClassifies[i].id
                      ? Colors.orange
                      : Colors.black),
            )),
          )));
    }
    return musicCategoryWidgetList;
  }
}
