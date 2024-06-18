import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie/router/index.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../main.dart';
import '../model/ClassMusicParamsModel.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import './MusicHomePage.dart';
import './MusicRecommentPage.dart';
import './MusicCirclePage.dart';
import './MusicUserPage.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/MusicModel.dart';
import '../../utils/LocalStroageUtils.dart';
import '../../config/common.dart';
import '../service/serverMethod.dart';

class MusicIndexPage extends StatefulWidget {
  MusicIndexPage({Key key}) : super(key: key);

  @override
  _MusicIndexPageState createState() => _MusicIndexPageState();
}

class _MusicIndexPageState extends State<MusicIndexPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin,RouteAware {
  @override
  bool get wantKeepAlive => true;

  /// 会重复播放的控制器
  AnimationController _repeatController;
  bool playing = false;

  /// 非线性动画
  Animation<double> _curveAnimation;
  int _currentIndex = 0;
  List<Widget> pages = [null, null, null, null];
  List<String> normalImgUrls = [
    "lib/assets/images/icon_home.png",
    "lib/assets/images/icon_recomment.png",
    "lib/assets/images/icon_music_circle.png",
    "lib/assets/images/icon_user.png"
  ];
  List<String> selectedImgUrls = [
    "lib/assets/images/icon_home_active.png",
    "lib/assets/images/icon_recomment_active.png",
    "lib/assets/images/icon_music_circle_active.png",
    "lib/assets/images/icon_user_active.png"
  ];
  List<String> titles = ["首页", "推荐", "音乐圈", "我的"];
  MusicModel musicModel;
  StreamSubscription onPlayerStateChangedListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 添加监听订阅
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  ///@author: wuwenqiang
  ///@description: 进入当前页面时
  ///@date: 2024-06-18 21:57
  @override
  void didPush() {
    super.didPush();
    onPlayerStateChangedListener?.resume();// 恢复监听音乐播放进度
  }

  ///@author: wuwenqiang
  ///@description: 从其他页面返回当前页面走这里
  ///@date: 2024-06-18 21:57
  @override
  void didPopNext() {
    super.didPopNext();
    onPlayerStateChangedListener?.resume();// 恢复监听音乐播放进度
  }

  ///@author: wuwenqiang
  ///@description: 退出当前页面，返回上一级页面
  ///@date: 2024-06-18 21:57
  @override
  void didPop() {
    super.didPop();
    onPlayerStateChangedListener.cancel();// 取消监听音乐播放进度
  }

  @override
  void dispose() {
    super.dispose();
    // 移除监听订阅
    MyApp.routeObserver.unsubscribe(this);
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _repeatController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // 创建一个从0到360弧度的补间动画 v * 2 * π
    _curveAnimation =
        Tween<double>(begin: 0, end: 1).animate(_repeatController);
    _repeatController.stop(canceled: false);
    usePlayState();
    getClassMusicList(); // 通过缓存参数获取上次播放的音乐列表
    LocalStroageUtils.getPlayMusic().then((value){
      if(value != null){
        Provider.of<PlayerMusicProvider>(context, listen: false).setPlayMusic([], MusicModel.fromJson(value), 0, false);
      }
    });
  }

  /// 获取播放状态
  usePlayState() {
    AudioPlayer player =
        Provider.of<PlayerMusicProvider>(context, listen: false).player;
    onPlayerStateChangedListener = player.onPlayerStateChanged.listen((event) {
      if (event.index == 2) {
        // 暂停播放
        _repeatController.stop(canceled: false);
      } else {
        // 恢复播放
        _repeatController.forward();
        _repeatController.repeat();
      }
    });
  }

  var _pageController = PageController();

  Widget _getPage() {
    if (pages[_currentIndex] == null) {
      if (_currentIndex == 0) {
        pages[_currentIndex] = MusicHomePage();
      } else if (_currentIndex == 1) {
        pages[_currentIndex] = MusicRecommentPage();
      } else if (_currentIndex == 2) {
        pages[_currentIndex] = MusicCirclePage();
      } else if (_currentIndex == 3) {
        pages[_currentIndex] = MusicUserPage();
      }
    }
    return pages[_currentIndex];
  }

  Widget bottomAppBarItem(int index) {
    //设置默认未选中的状态
    TextStyle style = TextStyle(color: Colors.grey);
    String imgUrl = normalImgUrls[index];
    if (_currentIndex == index) {
      //选中的话
      style = TextStyle(color: Colors.orange);
      imgUrl = selectedImgUrls[index];
    }
    //构造返回的Widget
    Widget item = Container(
      padding: EdgeInsets.only(
          top: ThemeSize.smallMargin, bottom: ThemeSize.smallMargin),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(imgUrl,
                width: ThemeSize.navigationIcon,
                height: ThemeSize.navigationIcon),
            SizedBox(height: ThemeSize.smallMargin),
            Text(
              titles[index],
              style: style,
            )
          ],
        ),
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
    return item;
  }

  ///  @desc 通过缓存参数获取上次播放的音乐列表
  ///  @data 2023-11-15 21:52
  ///  @author wuwenqiang
  void getClassMusicList() async {
    ClassMusicParamsModel classMusicParamsModel =
        await LocalStroageUtils.getClassMusicParams();
    if (classMusicParamsModel != null) {
      getMusicListByClassifyIdService(
              classMusicParamsModel.classifyId,
              classMusicParamsModel.pageNum,
              classMusicParamsModel.pageSize,
              classMusicParamsModel.isRedis)
          .then((res) {
        List<MusicModel> musicModelList =
            res.data.map((item) {
          item = {
            ...item,
            ...ClassMusicParamsModel.toMap(classMusicParamsModel)
          };
          return MusicModel.fromJson(item);
        });
        Provider.of<PlayerMusicProvider>(context)
            .setPlayMusicList(musicModelList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      MusicModel musicModel = Provider.of<PlayerMusicProvider>(context).musicModel;
      return Scaffold(
          backgroundColor: ThemeColors.colorBg,
          body: SafeArea(
              top: true,
              child: PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: _pageChanged,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _getPage();
                  })),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          //悬浮按钮
          floatingActionButton: SizedBox(
              height: ThemeSize.minPlayIcon,
              width: ThemeSize.minPlayIcon,
              child: FloatingActionButton(
                backgroundColor: ThemeColors.colorBg,
                child: musicModel != null
                    ? InkWell(
                    child: RotationTransition(
                        turns: _curveAnimation,
                        child: ClipOval(
                            child: Image.network(
                              HOST + musicModel.cover,
                              width: ThemeSize.minPlayIcon,
                              height: ThemeSize.minPlayIcon,
                            ))),
                    onTap: () {
                      Routes.router.navigateTo(context, '/MusicPlayerPage');
                    })
                    : Icon(Icons.music_note,color:ThemeColors.colorBg, size: ThemeSize.bigIcon),
                onPressed: () {},
              )),
          bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    bottomAppBarItem(0),
                    bottomAppBarItem(1),
                    SizedBox(width: 50),
                    bottomAppBarItem(2),
                    bottomAppBarItem(3)
                  ])));
  }

  void _pageChanged(int index) {
    setState(() {
      if (_currentIndex != index) _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }
}
