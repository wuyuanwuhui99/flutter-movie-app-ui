import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'pages/MoviePage.dart';
import 'pages/VideoPage.dart';
import 'pages/MyPage.dart';
import 'theme/ThemeColors.dart';
import './theme/ThemeSize.dart';
import './theme/ThemeColors.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  List<Widget> pages = [null, null, null, null];

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  List<String> normalImgUrls = [
    "lib/assets/images/icon-home.png",
    "lib/assets/images/icon-movie.png",
    "lib/assets/images/icon-tv.png",
    "lib/assets/images/icon-user.png"
  ];
  List<String> selectedImgUrls = [
    "lib/assets/images/icon-home-active.png",
    "lib/assets/images/icon-movie-active.png",
    "lib/assets/images/icon-tv-active.png",
    "lib/assets/images/icon-user-active.png"
  ];
  List<String> titles = ["首页", "电影", "电视剧", "我的"];

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

  var _pageController = PageController();

  Widget _getPage() {
    if (pages[_currentIndex] == null) {
      if (_currentIndex == 0) {
        pages[_currentIndex] = HomePage();
      } else if (_currentIndex == 1) {
        pages[_currentIndex] = MoviePage();
      } else if (_currentIndex == 2) {
        pages[_currentIndex] = VideoPage();
      } else if (_currentIndex == 3) {
        pages[_currentIndex] = MyPage();
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
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: _pageChanged,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _getPage();
                })),
        bottomNavigationBar: BottomAppBar(
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
