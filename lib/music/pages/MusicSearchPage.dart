import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../model/MusicModel.dart';
import "package:shared_preferences/shared_preferences.dart";
import '../../movie/component/TitleComponent.dart';
import '../service/serverMethod.dart';

class MusicSearchPage extends StatefulWidget {
  final String keyword;

  MusicSearchPage({Key key, this.keyword}) : super(key: key);

  @override
  _SearchMusicPageState createState() => _SearchMusicPageState();
}

class _SearchMusicPageState extends State<MusicSearchPage> {
  bool searching = false;
  bool loading = false;
  bool showClearIcon = false;
  int pageNum = 1;
  int pageSize = 20;
  List<MusicModel> searchResult = [];
  List<Widget> myHistoryLabels = [];
  List<String> myHistoryLabelsName = [];
  TextEditingController keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String historyLabels = prefs.getString('historyMusicLabels');
    if (historyLabels != null && historyLabels != '') {
      setState(() {
        myHistoryLabelsName = historyLabels.split(",");
        int length =
        myHistoryLabelsName.length <= 20 ? myHistoryLabelsName.length : 20;
        for (int i = 0; i < length; i++) {
          myHistoryLabels.add(Label(myHistoryLabelsName[i]));
        }
      });
    }
  }

  ///@author: wuwenqiang
  ///@description: 搜索
  /// @date: 2024-01-27 16:46
  goSearch(){
    searchMusicService(Uri.encodeComponent(keywordController.text),pageNum,pageSize).then((res){
      setState(() {
        loading = false;
        searchResult = (res["data"] as List).cast().map((item) {
          return MusicModel.fromJson(item);
        }).toList(); // 顶部轮播组件数
        print('--------');
        print(searchResult.length);
      });
    }).catchError(() {
      setState(() {
        searching = true;
      });
    });;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,

        body: SafeArea(
          top: true,
          child: Container(
              padding: ThemeStyle.paddingBox,
            child: EasyRefresh(
              footer: MaterialFooter(),
              onLoad: () async {
                // if(sea)
                // pageNum++;
                // if (pageNum >= allClassifies.length) {
                //   Fluttertoast.showToast(
                //       msg: "已经到底了",
                //       toastLength: Toast.LENGTH_SHORT,
                //       gravity: ToastGravity.CENTER,
                //       timeInSecForIos: 1,
                //       backgroundColor: Colors.blue,
                //       textColor: Colors.white,
                //       fontSize: ThemeSize.middleFontSize);
                // } else {
                //   _getCategoryItem();
                // }
              },
              child: Column(children: [
                buildSearchInputWidget(),
                this.searching ? (
                  this.loading ? SizedBox() : buildMusicListWidget()
                ) : Column(children: [
                  buildHistorySearchWidget()
                ],)
              ],),
            )),
          ),
        );
  }

  Widget buildSearchInputWidget(){
    return Container(
      decoration: ThemeStyle.boxDecoration,
      padding: ThemeStyle.padding,
      margin: ThemeStyle.margin,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  height: ThemeSize.buttonHeight,
                  //修饰黑色背景与圆角
                  decoration: new BoxDecoration(
                    color: ThemeColors.colorBg,
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(ThemeSize.superRadius)),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: ThemeSize.smallMargin*2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:
                          TextField(
                              controller: keywordController,
                              cursorColor: Colors.grey, //设置光标
                              decoration: InputDecoration(
                                hintText: widget.keyword,
                                hintStyle:
                                TextStyle(fontSize: ThemeSize.smallFontSize, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.only(bottom: ThemeSize.smallMargin),
                              ))),
                      showClearIcon
                          ? InkWell(
                          onTap: () {
                            setState(() {
                              keywordController.text = ""; //清除输入框的值
                              searching = false;
                              showClearIcon = false;
                            });
                          },
                          child: Image.asset(
                            "lib/assets/images/icon-clear.png",
                            height: ThemeSize.smallIcon,
                            width: ThemeSize.smallIcon,
                          ))
                          : SizedBox(),
                      SizedBox(width: ThemeSize.smallMargin)
                    ],
                  )),
              flex: 1),
          SizedBox(width: ThemeSize.smallMargin),
          Container(
              height: ThemeSize.buttonHeight,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  if(this.loading)return;
                  this.setState(() {
                    this.searching = this.loading = true;
                  });
                  if (keywordController.text == "")
                    keywordController.text = widget.keyword;
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  int index =
                  myHistoryLabelsName.indexOf(keywordController.text);
                  if (index != -1) {
                    myHistoryLabelsName.removeAt(index);
                    myHistoryLabelsName.insert(0, keywordController.text);
                  } else {
                    myHistoryLabelsName.add(keywordController.text);
                  }
                  prefs.setString("historyMusicLabels", myHistoryLabelsName.join(","));
                  setState(() {
                    showClearIcon = true;
                    myHistoryLabels.insert(0, Label(keywordController.text));
                  });
                  goSearch();
                },
                child: Text(
                  '搜索',
                  style: TextStyle(
                      fontSize: ThemeSize.middleFontSize, color: Colors.white),
                ),

                ///圆角
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(ThemeSize.bigRadius))),
              ))
        ],
      ),
    );
  }

  Widget Label(String text) {
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      color: Color.fromARGB(255, 230, 230, 230),
      onPressed: () {
        setState(() {
          keywordController.text = text;
          searching = true;
          showClearIcon = true;
        });
        // goSearch();
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.grey),
      ),

      ///圆角
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50))),
    );
  }

  Widget buildHistorySearchWidget() {
    return Container(
      decoration: ThemeStyle.boxDecoration,
      padding: ThemeStyle.padding,
      margin: ThemeStyle.margin,
      alignment: Alignment.centerLeft,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleComponent(title: "历史搜索"),
            myHistoryLabels.length > 0
                ? Wrap(
              spacing: ThemeSize.smallMargin,
              children: myHistoryLabels,
            )
                : Container(
              height: 80,
              child: Text("暂无搜索记录"),
              alignment: Alignment.center,
            )
          ]),
    );
  }
  
  Widget buildMusicListWidget(){
    return Container(
        child: searchResult.length > 0 ?
            Column(children:
              searchResult.map((musicItem){
                return Text(musicItem.songName);
              }).toList()
            )
        : Text("暂无数据")
      );
  }
}
