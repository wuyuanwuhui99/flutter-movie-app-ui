import 'package:flutter/material.dart';
import 'MovieHomePage.dart';
import 'MoviePage.dart';
import 'VideoPage.dart';
import 'MovieMyPage.dart';
import '../theme/ThemeColors.dart';
import '../theme/ThemeSize.dart';


class MovieIndexPage extends StatefulWidget {
  const MovieIndexPage({super.key});

  @override
  MovieIndexPageState createState() => MovieIndexPageState();
}

class MovieIndexPageState extends State<MovieIndexPage> {
  int _currentIndex = 0;
  List<Widget?> pages = [null, null, null, null];
  bool isInit = false;
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  List<String> icons = [
    "lib/assets/images/icon_home.png",
    "lib/assets/images/icon_movie.png",
    "lib/assets/images/icon_tv.png",
    "lib/assets/images/icon_user.png"
  ];

  List<String> titles = ["首页", "电影", "电视剧", "我的"];

  Widget bottomAppBarItem(int index) {
    //设置默认未选中的状态
    TextStyle style = const TextStyle(color: Colors.grey);
    if (_currentIndex == index) {
      //选中的话
      style = const TextStyle(color: Colors.orange);
    }
    //构造返回的Widget

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: <Widget>[
          Image.asset(icons[index],
              color: _currentIndex == index ? Colors.orange : Colors.black,
              width: ThemeSize.navigationIcon,
              height: ThemeSize.navigationIcon),
          SizedBox(height: ThemeSize.smallMargin),
          Text(
            titles[index],
            style: TextStyle(color: _currentIndex == index ? Colors.orange : Colors.black),
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
    );
  }

  final _pageController = PageController();

  Widget? _getPage() {
    if (pages[_currentIndex] == null) {
      if (_currentIndex == 0) {
        pages[_currentIndex] = const MovieHomePage();
      } else if (_currentIndex == 1) {
        pages[_currentIndex] = const MoviePage();
      } else if (_currentIndex == 2) {
        pages[_currentIndex] = VideoPage();
      } else if (_currentIndex == 3) {
        pages[_currentIndex] = const MovieMyPage();
      }
    }
    return pages[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
            top: true,
            child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _pageChanged,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _getPage();
                })),
        bottomNavigationBar: BottomAppBar(
            height:ThemeSize.bottomBarHeight,
            color: ThemeColors.colorWhite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                bottomAppBarItem(0),
                bottomAppBarItem(1),
                bottomAppBarItem(2),
                bottomAppBarItem(3)
              ],
            )));

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
