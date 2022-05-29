import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../config/serviceUrl.dart';
import '../provider/UserInfoProvider.dart';
import './login_page.dart';
import './EditPage.dart';
import '../model/UserInfoModel.dart';
import '../theme/ThemeColors.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeStyle.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(top: true,child:  Container(
            padding: ThemeStyle.paddingBox,
            child: Column(
              children: <Widget>[
                Container(
                  padding: ThemeStyle.padding,
                  decoration: ThemeStyle.boxDecoration,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: ThemeStyle.bottomDecoration,
                        padding:
                        EdgeInsets.only(bottom: ThemeSize.containerPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("头像"),
                              flex: 1,
                            ),
                            ClipOval(
                              child: Image.network(
                                //从全局的provider中获取用户信息
                                serviceUrl + userInfo.avater,
                                height: ThemeSize.bigAvater,
                                width: ThemeSize.bigAvater,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: ThemeSize.smallMargin),
                            Image.asset("lib/assets/images/icon-arrow.png",
                                height: ThemeSize.miniIcon,
                                width: ThemeSize.miniIcon,
                                fit: BoxFit.cover),
                          ],
                        ),
                      ),
                      Container(
                        decoration: ThemeStyle.bottomDecoration,
                        padding: ThemeStyle.columnPadding,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      title: "昵称",
                                      value: userInfo.username,
                                      type: "input",
                                      isAllowEmpty: false,
                                      field: "username",
                                    )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text("昵称"),
                                flex: 1,
                              ),
                              Text(userInfo.username),
                              SizedBox(width: ThemeSize.smallMargin),
                              Image.asset("lib/assets/images/icon-arrow.png",
                                  height: ThemeSize.miniIcon,
                                  width: ThemeSize.miniIcon,
                                  fit: BoxFit.cover),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          decoration: ThemeStyle.bottomDecoration,
                          padding: ThemeStyle.columnPadding,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPage(
                                          title: "电话",
                                          value: userInfo.telephone,
                                          type: "input",
                                          isAllowEmpty: false,
                                          field: "telphone",
                                        )));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("电话"),
                                    flex: 1,
                                  ),
                                  Text(userInfo.telephone),
                                  SizedBox(width: ThemeSize.smallMargin),
                                  Image.asset(
                                      "lib/assets/images/icon-arrow.png",
                                      height: ThemeSize.miniIcon,
                                      width: ThemeSize.miniIcon,
                                      fit: BoxFit.cover),
                                ],
                              ))),
                      Container(
                        decoration: ThemeStyle.bottomDecoration,
                        padding: ThemeStyle.columnPadding,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      title: "邮箱",
                                      value: userInfo.email,
                                      type: "input",
                                      isAllowEmpty: false,
                                      field: "email",
                                    )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text("邮箱"),
                                flex: 1,
                              ),
                              Text(userInfo.email),
                              SizedBox(width: ThemeSize.smallMargin),
                              Image.asset("lib/assets/images/icon-arrow.png",
                                  height: ThemeSize.miniIcon,
                                  width: ThemeSize.miniIcon,
                                  fit: BoxFit.cover),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: ThemeStyle.bottomDecoration,
                        padding: ThemeStyle.columnPadding,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        title: "出生年月日",
                                        value: userInfo.birthday,
                                        type: "date",
                                        isAllowEmpty: true,
                                        field: "birthday",
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text("出生年月日"),
                                  flex: 1,
                                ),
                                Text(userInfo.birthday),
                                SizedBox(width: ThemeSize.smallMargin),
                                Image.asset("lib/assets/images/icon-arrow.png",
                                    height: ThemeSize.miniIcon,
                                    width: ThemeSize.miniIcon,
                                    fit: BoxFit.cover),
                              ],
                            )),
                      ),
                      Container(
                          decoration: ThemeStyle.bottomDecoration,
                          padding: ThemeStyle.columnPadding,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        title: "性别",
                                        value: userInfo.sex,
                                        type: "radio",
                                        isAllowEmpty: false,
                                        field: "sex",
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text("性别"),
                                  flex: 1,
                                ),
                                Text(userInfo.sex),
                                SizedBox(width: ThemeSize.smallMargin),
                                Image.asset("lib/assets/images/icon-arrow.png",
                                    height: ThemeSize.miniIcon,
                                    width: ThemeSize.miniIcon,
                                    fit: BoxFit.cover),
                              ],
                            ),
                          )),
                      Container(
                          decoration: ThemeStyle.bottomDecoration,
                          padding: ThemeStyle.columnPadding,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        title: "个性签名",
                                        value: userInfo.sign,
                                        type: "input",
                                        isAllowEmpty: false,
                                        field: "sign",
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text("个性签名"),
                                  flex: 1,
                                ),
                                Text(
                                    userInfo.sign != null ? userInfo.sign : ""),
                                SizedBox(width: ThemeSize.smallMargin),
                                Image.asset("lib/assets/images/icon-arrow.png",
                                    height: ThemeSize.miniIcon,
                                    width: ThemeSize.miniIcon,
                                    fit: BoxFit.cover),
                              ],
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              top: ThemeSize.columnPadding,
                              bottom: ThemeSize.columnPadding -
                                  ThemeSize.containerPadding),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        title: "地区",
                                        value: userInfo.region,
                                        type: "input",
                                        isAllowEmpty: false,
                                        field: "region",
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text("地区"),
                                  flex: 1,
                                ),
                                Text(userInfo.region != null
                                    ? userInfo.region
                                    : ""),
                                SizedBox(width: ThemeSize.smallMargin),
                                Image.asset("lib/assets/images/icon-arrow.png",
                                    height: ThemeSize.miniIcon,
                                    width: ThemeSize.miniIcon,
                                    fit: BoxFit.cover),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ThemeSize.containerPadding),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(ThemeSize.superRadius)),
                  ),
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      _showDialog(context);
                    },
                    child: Text("退出登录",
                        style:
                        TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )))
       );
  }
}

enum Action { Ok, Cancel }

Future _showDialog(context) async {
  final action = await showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text('确认退出？'),
        actions: [
          CupertinoDialogAction(
            child: Text('确认'),
            onPressed: () {
              Navigator.pop(context, Action.Ok);
            },
          ),
          CupertinoDialogAction(
            child: Text('取消'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, Action.Cancel);
            },
          ),
        ],
      );
    },
  );

  switch (action) {
    case Action.Ok:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      break;
    case Action.Cancel:
      break;
    default:
  }
}
