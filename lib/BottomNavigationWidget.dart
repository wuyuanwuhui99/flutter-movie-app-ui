import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './movie/service/serverMethod.dart';
import './movie/pages/MovieHomePage.dart';
import './movie/pages/MoviePage.dart';
import './movie/pages/VideoPage.dart';
import './movie/pages/MovieMyPage.dart';
import './theme/ThemeColors.dart';
import './theme/ThemeSize.dart';
import './movie/model/UserInfoModel.dart';
import './movie/provider/UserInfoProvider.dart';


class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
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

  List<String> normalImgUrls = [
    "lib/assets/images/icon_home.png",
    "lib/assets/images/icon_movie.png",
    "lib/assets/images/icon_tv.png",
    "lib/assets/images/icon_user.png"
  ];
  List<String> selectedImgUrls = [
    "lib/assets/images/icon_home_active.png",
    "lib/assets/images/icon_movie_active.png",
    "lib/assets/images/icon_tv_active.png",
    "lib/assets/images/icon_user_active.png"
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
