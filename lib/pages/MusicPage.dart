import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../model/UserInfoModel.dart';
import '../model/UserMsgModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../pages/MusicHomePage.dart';
import '../pages/MusicRecommentPage.dart';
import '../pages/MusicCirclePage.dart';
import '../pages/MusicUserPage.dart';

class MusicPage extends StatefulWidget {
  MusicPage({Key key}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
        pages[currentIndex] = MusicHomePage();
      } else if (currentIndex == 1) {
        pages[currentIndex] = MusicRecommentPage();
      } else if (currentIndex == 2) {
        pages[currentIndex] = MusicCirclePage();
      } else if (currentIndex == 3) {
        pages[currentIndex] = MusicUserPage();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //悬浮按钮
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            print('点击');
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              InkWell(
                  onTap: (){},
                  child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        _currentIndex == 0
                            ? "lib/assets/images/icon-home-active.png"
                            : "lib/assets/images/icon-home.png",
                        width: ThemeSize.smallIcon,
                        height: ThemeSize.smallIcon),
                    SizedBox(height: ThemeSize.miniMargin),
                    Text(
                      "首页",
                      style: TextStyle(
                          color: _currentIndex == 0
                              ? Colors.orange
                              : Colors.grey),
                    ),
                  ])),
                InkWell(
                    onTap: (){},
                    child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                              _currentIndex == 0
                                  ? "lib/assets/images/icon-home-active.png"
                                  : "lib/assets/images/icon-home.png",
                              width: ThemeSize.smallIcon,
                              height: ThemeSize.smallIcon),
                          SizedBox(height: ThemeSize.miniMargin),
                          Text(
                            "首页",
                            style: TextStyle(
                                color: _currentIndex == 0
                                    ? Colors.orange
                                    : Colors.grey),
                          ),
                        ])),InkWell(
                    onTap: (){},
                    child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                              _currentIndex == 0
                                  ? "lib/assets/images/icon-home-active.png"
                                  : "lib/assets/images/icon-home.png",
                              width: ThemeSize.smallIcon,
                              height: ThemeSize.smallIcon),
                          SizedBox(height: ThemeSize.miniMargin),
                          Text(
                            "首页",
                            style: TextStyle(
                                color: _currentIndex == 0
                                    ? Colors.orange
                                    : Colors.grey),
                          ),
                        ])),InkWell(
                    onTap: (){},
                    child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                              _currentIndex == 0
                                  ? "lib/assets/images/icon-home-active.png"
                                  : "lib/assets/images/icon-home.png",
                              width: ThemeSize.smallIcon,
                              height: ThemeSize.smallIcon),
                          SizedBox(height: ThemeSize.miniMargin),
                          Text(
                            "首页",
                            style: TextStyle(
                                color: _currentIndex == 0
                                    ? Colors.orange
                                    : Colors.grey),
                          ),
                        ]))


//                Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      Image.asset(
//                          _currentIndex == 0
//                              ? "lib/assets/images/icon-home-active.png"
//                              : "lib/assets/images/icon-home.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "首页",
//                        style: TextStyle(
//                            color: _currentIndex == 0
//                                ? Colors.orange
//                                : Colors.grey),
//                      ),
//                    ]),
//                Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      Image.asset(
//                          _currentIndex == 1
//                              ? "lib/assets/images/icon-recomment-active.png"
//                              : "lib/assets/images/icon-recomment.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "推荐",
//                        style: TextStyle(
//                            color: _currentIndex == 1
//                                ? Colors.orange
//                                : Colors.grey),
//                      ),
//                    ]),
//                SizedBox(width: 50),
//                Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      Image.asset(
//                          _currentIndex == 2
//                              ? "lib/assets/images/icon-music-cicle-active.png"
//                              : "lib/assets/images/icon-music-cicle.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "音乐圈",
//                        style: TextStyle(
//                            color: _currentIndex == 2
//                                ? Colors.orange
//                                : Colors.grey),
//                      ),
//                    ]),
//                Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      Image.asset(
//                          _currentIndex == 3
//                              ? "lib/assets/images/icon-user-active.png"
//                              : "lib/assets/images/icon-user.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "我的",
//                        style: TextStyle(
//                            color: _currentIndex == 3
//                                ? Colors.orange
//                                : Colors.grey),
//                      ),
//                    ]),
              ]),
        )
//        bottomNavigationBar: BottomAppBar(
//            shape: CircularNotchedRectangle(),
//            child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  Expanded(child: Column(
//                    children: <Widget>[
//                      Image.asset(_currentIndex == 0
//                          ? "lib/assets/images/icon-home-active.png"
//                          : "lib/assets/images/icon-home.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon
//                      ),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "首页",
//                        style: TextStyle(
//                            color: _currentIndex == 0 ? Colors.orange : Colors
//                                .grey),
//                      )
//                    ],
//                  ), flex: 1),
//                  Expanded(child: Column(
//                    children: <Widget>[
//                      Image.asset(_currentIndex == 1
//                          ? "lib/assets/images/icon-recomment-active.png"
//                          : "lib/assets/images/icon-recomment.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon
//                      ),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "推荐",
//                        style: TextStyle(
//                            color: _currentIndex == 1 ? Colors.orange : Colors
//                                .grey),
//                      )
//                    ],
//                  ), flex: 1),
//                  SizedBox(width: 100),
//                  Expanded(child: Column(
//                    children: <Widget>[
//                      Image.asset(_currentIndex == 2
//                          ? "lib/assets/images/icon-music-circle-active.png"
//                          : "lib/assets/images/icon-music-circle.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon
//                      ),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "音乐圈",
//                        style: TextStyle(
//                            color: _currentIndex == 2 ? Colors.orange : Colors
//                                .grey),
//                      )
//                    ],
//                  ), flex: 1),
//                  Expanded(child: Column(
//                    children: <Widget>[
//                      Image.asset(_currentIndex == 3
//                          ? "lib/assets/images/icon-user-active.png"
//                          : "lib/assets/images/icon-user.png",
//                          width: ThemeSize.smallIcon,
//                          height: ThemeSize.smallIcon
//                      ),
//                      SizedBox(height: ThemeSize.miniMargin),
//                      Text(
//                        "我的",
//                        style: TextStyle(
//                            color: _currentIndex == 3 ? Colors.orange : Colors
//                                .grey),
//                      )
//                    ],
//                  ), flex: 1)
//                ]))

//      bottomNavigationBar: BottomNavigationBar(
//        type: BottomNavigationBarType.fixed,
//        currentIndex: _currentIndex,
//        onTap: onTabTapped,
//        items: [
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.home,
//                color: _currentIndex == 0 ? Colors.orange : Colors.grey,
//              ),
//              title: Text(
//                "首页",
//                style: TextStyle(
//                    color: _currentIndex == 0 ? Colors.orange : Colors.grey),
//              )),
//          BottomNavigationBarItem(
//              icon: Image(image: AssetImage("lib/assets/images/icon-recomment.png"),
//                  width: ThemeSize.smallIcon,
//                  height: ThemeSize.smallIcon),
//              activeIcon:Image(image: AssetImage("lib/assets/images/icon-recomment-active.png"),
//                  width: ThemeSize.smallIcon,
//                  height: ThemeSize.smallIcon),
//              title: Text(
//                "推荐",
//                style: TextStyle(
//                    color: _currentIndex == 1 ? Colors.orange : Colors.grey),
//              )),
//          BottomNavigationBarItem(
//              icon: Image(image: AssetImage("lib/assets/images/icon-music-circle.png"),
//                  width: ThemeSize.smallIcon,
//                  height: ThemeSize.smallIcon),
//              activeIcon:Image(image: AssetImage("lib/assets/images/icon-music-circle-active.png"),
//                  width: ThemeSize.smallIcon,
//                  height: ThemeSize.smallIcon),
//              title: Text(
//                "音乐圈",
//                style: TextStyle(
//                    color: _currentIndex == 2 ? Colors.orange : Colors.grey),
//              )),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.person,
//                color: _currentIndex == 3 ? Colors.orange : Colors.grey,
//              ),
//              title: Text(
//                "我的",
//                style: TextStyle(
//                    color: _currentIndex == 3 ? Colors.orange : Colors.grey),
//              )),
//        ],
//      ),
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
