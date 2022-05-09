import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'pages/MoviePage.dart';
import 'pages/VideoPage.dart';
import 'pages/MyPage.dart';
import 'theme/ThemeColors.dart';
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

  var _pageController = PageController();

  Widget _getPage(int currentIndex) {
    if (pages[currentIndex] == null) {
      if (currentIndex == 0) {
        pages[currentIndex] = HomePage();
      } else if (currentIndex == 1) {
        pages[currentIndex] = MoviePage();
      } else if (currentIndex == 2) {
        pages[currentIndex] = VideoPage();
      } else if (currentIndex == 3) {
        pages[currentIndex] = MyPage();
      }
    }
    return pages[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.colorBg,
      body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChanged,
          itemCount: 4,
          itemBuilder: (context, index) {
            return _getPage(index);
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.orange : Colors.grey,
              ),
              title: Text(
                "首页",
                style: TextStyle(
                    color: _currentIndex == 0 ? Colors.orange : Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.movie,
                // IconData(0xe614, fontFamily: 'hot'),
                color: _currentIndex == 1 ? Colors.orange : Colors.grey,
              ),
              title: Text(
                "电影",
                style: TextStyle(
                    color: _currentIndex == 1 ? Colors.orange : Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.video_label,
                color: _currentIndex == 2 ? Colors.orange : Colors.grey,
              ),
              title: Text(
                "电视剧",
                style: TextStyle(
                    color: _currentIndex == 2 ? Colors.orange : Colors.grey),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 3 ? Colors.orange : Colors.grey,
              ),
              title: Text(
                "我的",
                style: TextStyle(
                    color: _currentIndex == 3 ? Colors.orange : Colors.grey),
              )),
        ],
      ),
    );
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
