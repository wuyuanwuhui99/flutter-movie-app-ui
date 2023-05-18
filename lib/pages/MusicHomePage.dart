import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../config/serviceUrl.dart';
import './SearchMusicPage.dart';

class MusicHomePage extends StatefulWidget {
  MusicHomePage({Key key}) : super(key: key);

  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[buildSearchWidget()],
    );
  }

  Widget buildSearchWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.network(
                //从全局的provider中获取用户信息
                movieServiceUrl +
                    Provider.of<UserInfoProvider>(context).userInfo.avater,
                height: ThemeSize.middleAvater,
                width: ThemeSize.middleAvater,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.only(left: ThemeSize.smallMargin),
                    child: FutureBuilder(
                        future: getKeyWordMusicService(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          // var result = json.decode(snapshot.data.toString());
                          var result = snapshot.data;
                          String keyword = "";
                          if (result != null && result['data'] != null) {
                            keyword =
                                '${result["data"]["authorName"]} - ${result["data"]["songName"]}';
                          }
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchMusicPage(keyword: keyword)));
                              },
                              child: Container(
                                  height: ThemeSize.buttonHeight,
                                  //修饰黑色背景与圆角
                                  decoration: new BoxDecoration(
                                    color: ThemeColors.colorBg,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(
                                            ThemeSize.bigRadius)),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left: ThemeSize.containerPadding),
                                  child: Text(
                                    keyword,
                                    style: TextStyle(color: Colors.grey),
                                  )));
                        })))
          ],
        ));
  }
}
