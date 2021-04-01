import 'package:flutter/material.dart';
import 'dart:ui';
import "package:shared_preferences/shared_preferences.dart";
import 'dart:convert';
import '../config/service_url.dart';
import '../service/server_method.dart';
import "./detail_page.dart";
import '../component/ScoreComponent.dart';
import '../component/RecommendComponent.dart';

class SearchPage extends StatefulWidget {
  final String keyword;
  SearchPage({Key key, this.keyword}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool searching = false;
  bool showClearIcon = false;
  List<Map> searchResult = [];
  List<Widget> myHistoryLabels = [];
  List<String> myHistoryLabelsName = [];
  TextEditingController keywordController = TextEditingController();
  @override
  void initState() {
    keywordController.addListener(() {
      setState(() {
        showClearIcon = keywordController.text != "";
      });
    });
    _getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: 20,
            top: MediaQuery.of(context).padding.top,
            bottom: 20,
            right: 20),
        child: Column(
          children: <Widget>[
            SearchInputComponent(),
            searching
                ? Expanded(
                    flex: 1,
                    child: searchResult.length == 0
                        ? Center(
                            child: Text(
                            "没有查询到影片",
                            style: TextStyle(fontSize: 20),
                          ))
                        : SearchResult())
                : Expanded(flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children:<Widget>[
                      HistorySearchComponent(),
                      SizedBox(height: 20),
                      SingleChildScrollView(child: RecommendComponent(),)
                ]))
        ),
      ]),
    ));
  }

  Widget SearchResult() {
    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(movieItem: searchResult[index])));
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 200,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(searchResult[index]
                                        ["localImg"] !=
                                    null
                                ? serviceUrl + searchResult[index]["localImg"]
                                : searchResult[index]["img"]))),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  searchResult[index]["movieName"],
                                  style: TextStyle(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    searchResult[index]["star"] != null
                                        ? "主演：" + searchResult[index]["star"]
                                        : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(height: 10),
                                Text(
                                    searchResult[index]["director"] != null
                                        ? "导演：" +
                                            searchResult[index]["director"]
                                        : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(height: 10),
                                Text(
                                    searchResult[index]["type"] != null
                                        ? "类型：" + searchResult[index]["type"]
                                        : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(height: 10),
                                Text(
                                    searchResult[index]["releaseTime"] != null
                                        ? "上映时间：" +
                                            searchResult[index]["releaseTime"]
                                        : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(height: 10),
                                ScoreComponent(
                                    score: searchResult[index]["score"]),
                                SizedBox(height: 10),
                              ],
                            ),
                          )))
                ],
              ),
            ));
      },
    );
  }

  Widget SearchInputComponent() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
                height: 40,
                //修饰黑色背景与圆角
                decoration: new BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 241, 242, 246),
                      width: 1.0), //灰色的一层边框
                  color: Color.fromARGB(255, 230, 230, 230),
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10,top:0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: TextField(
                            controller: keywordController,
                            cursorColor: Colors.grey, //设置光标
                            decoration: InputDecoration(
                              hintText: widget.keyword,
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              contentPadding: EdgeInsets.only(left: 10,top: 0),
                              border: InputBorder.none,
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
                              height: 20,
                              width: 20,
                            ))
                        : SizedBox(),
                    SizedBox(width: 10)
                  ],
                )),
            flex: 1),
        SizedBox(width: 10),
        RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () async {
            if (keywordController.text == "")
              keywordController.text = widget.keyword;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            int index = myHistoryLabelsName.indexOf(keywordController.text);
            if (index != -1) {
              myHistoryLabelsName.removeAt(index);
              myHistoryLabelsName.insert(0, keywordController.text);
            } else {
              myHistoryLabelsName.add(keywordController.text);
            }
            prefs.setString("historyLabel", json.encode(myHistoryLabelsName));
            setState(() {
              showClearIcon = true;
              myHistoryLabels.insert(0, Label(keywordController.text));
            });
            goSearch();
          },
          child: Text(
            '搜索',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),

          ///圆角
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(50))),
        )
      ],
    );
  }

  void goSearch() {
    getSearchResult(keywordController.text, pageSize: 20, pageNum: 1)
        .then((res) {
      setState(() {
        searching = true;
        searchResult = (res["data"] as List).cast(); // 顶部轮播组件数
      });
    }).catchError(() {
      setState(() {
        searching = true;
      });
    });
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
        goSearch();
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

  _getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String historyLabels = prefs.getString('historyLabels');
    if (historyLabels != null) {
      setState(() {
        myHistoryLabelsName = json.decode(historyLabels);
        int length =
            myHistoryLabelsName.length <= 20 ? myHistoryLabelsName.length : 20;
        for (int i = 0; i < length; i++) {
          myHistoryLabels.add(Label(myHistoryLabelsName[i]));
        }
      });
    }
  }

  Widget HistorySearchComponent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Row(children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3, //宽度
                      color: Colors.blue, //边框颜色
                    ),
                  ),
                ),
                child: Text("历史搜索"))
          ]),
          SizedBox(height: 15),
          myHistoryLabels.length > 0 ?
          Wrap(
            spacing: 10,
            children: myHistoryLabels,
          ):
              Container(
                  height: 80,
                  child: Text("暂时搜索记录"),
                  alignment: Alignment.center,
              )
        ]);
  }
}
