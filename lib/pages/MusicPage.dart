import 'package:flutter/material.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../pages/MusicHomePage.dart';
import '../pages/MusicRecommentPage.dart';
import '../pages/MusicCirclePage.dart';
import '../pages/MusicUserPage.dart';
import 'package:provider/provider.dart';
import '../provider/PlayerMusicProvider.dart';
import '../model/MusicModel.dart';
import '../utils/LocalStroageUtils.dart';
import '../config/serviceUrl.dart';
import 'package:audioplayers/audioplayers.dart';
import '../pages/MusicPlayerPage.dart';

class MusicPage extends StatefulWidget {
  MusicPage({Key key}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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
    "lib/assets/images/icon-home.png",
    "lib/assets/images/icon-recomment.png",
    "lib/assets/images/icon-music-circle.png",
    "lib/assets/images/icon-user.png"
  ];
  List<String> selectedImgUrls = [
    "lib/assets/images/icon-home-active.png",
    "lib/assets/images/icon-recomment-active.png",
    "lib/assets/images/icon-music-circle-active.png",
    "lib/assets/images/icon-user-active.png"
  ];
  List<String> titles = ["首页", "推荐", "音乐圈", "我的"];

  @override
  void dispose() {
    super.dispose();
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
  }

  /// 获取播放状态
  usePlayState() {
    AudioPlayer player = Provider.of<PlayerMusicProvider>(context, listen: false).player;
    player.onPlayerStateChanged.listen((event) {
      print(event.index);
      if (event.index == 2) {
        // 暂停播放
        _repeatController.stop(canceled: false);
      } else {// 恢复播放
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LocalStroageUtils.getPlayMusic(),
        builder: (context, snapshot) {
          MusicModel musicModel =
              Provider.of<PlayerMusicProvider>(context).musicModel;
          if (snapshot.data == null && musicModel == null) {
            return SizedBox();
          } else if (musicModel == null) {
            musicModel = MusicModel.fromJson(snapshot.data);
            Provider.of<PlayerMusicProvider>(context)
                .setPlayMusic(musicModel, false);
          }
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
                                  host + musicModel.cover,
                                  width: ThemeSize.minPlayIcon,
                                  height: ThemeSize.minPlayIcon,
                                ))),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MusicPlayerPage()));
                            })
                        : Icon(Icons.music_note, size: ThemeSize.middleIcon),
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
        });
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
