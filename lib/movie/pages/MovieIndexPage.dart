import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import 'MovieHomePage.dart';
import 'MoviePage.dart';
import 'VideoPage.dart';
import 'MovieMyPage.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../model/UserInfoModel.dart';
import '../provider/UserInfoProvider.dart';


class MovieIndexPage extends StatefulWidget {
  _MovieIndexPageState createState() => _MovieIndexPageState();
}

class _MovieIndexPageState extends State<MovieIndexPage> {
  int _currentIndex = 0;
  List<Widget> pages = [null, null, null, null];
  bool isInit = false;
  @override
  void initState(){
    super.initState();
    getUserDataService().then((value){
      Provider.of<UserInfoProvider>(context,listen: false).setUserInfo(UserInfoModel.fromJson(value.data));
      setState(() {
        isInit = true;
      });
    });
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
    TextStyle style = TextStyle(color: Colors.grey);
    if (_currentIndex == index) {
      //选中的话
      style = TextStyle(color: Colors.orange);
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
      ),
    );
    return item;
  }

  var _pageController = PageController();

  Widget _getPage() {
    if (pages[_currentIndex] == null) {
      if (_currentIndex == 0) {
        pages[_currentIndex] = MovieHomePage();
      } else if (_currentIndex == 1) {
        pages[_currentIndex] = MoviePage();
      } else if (_currentIndex == 2) {
        pages[_currentIndex] = VideoPage();
      } else if (_currentIndex == 3) {
        pages[_currentIndex] = MovieMyPage();
      }
    }
    return pages[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    if(isInit){
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
    }else{
      return  Scaffold(body:  Center(
        child: CircularProgressIndicator(),
      ));
    }

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
