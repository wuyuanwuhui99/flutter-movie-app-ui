import 'package:flutter/material.dart';
import '../config/service_url.dart';
import '../provider/UserInfoProvider.dart';
import 'package:provider/provider.dart';
import './login_page.dart';
import 'package:flutter/cupertino.dart';
import './edit_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(237, 237, 237, 1)),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                        )),
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
                                serviceUrl + userInfo["avater"],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset("lib/assets/images/icon-arrow.png",
                                height: 15, width: 15, fit: BoxFit.cover),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                        )),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute( builder: (context) => EditPage( title: "昵称",value: userInfo["username"],type: "input",)));
                          },
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("昵称"),
                              flex: 1,
                            ),
                            Text(userInfo["username"]),
                            SizedBox(width: 10),
                            Image.asset("lib/assets/images/icon-arrow.png",
                                height: 15, width: 15, fit: BoxFit.cover),
                          ],
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                        )),
                        child:
                        InkWell(
                            onTap:(){
                              Navigator.push(context,MaterialPageRoute( builder: (context) => EditPage( title: "电话",value:userInfo["telphone"],type: "input",)));
                            },
                            child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("电话"),
                              flex: 1,
                            ),
                            Text(userInfo["telephone"]),
                            SizedBox(width: 10),
                            Image.asset("lib/assets/images/icon-arrow.png",
                                height: 15, width: 15, fit: BoxFit.cover),
                          ],
                        ))

                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                        )),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute( builder: (context) => EditPage( title: "邮箱",value: userInfo["email"],type:"input")));
                          },
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("邮箱"),
                              flex: 1,
                            ),
                            Text(userInfo["email"]),
                            SizedBox(width: 10),
                            Image.asset("lib/assets/images/icon-arrow.png",
                                height: 15, width: 15, fit: BoxFit.cover),
                          ],
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                        )),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute( builder: (context) => EditPage( title: "出生年月日",value: userInfo["bitthday"],type:"date")));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text("出生年月日"),
                                flex: 1,
                              ),
                              Text(userInfo["birthday"]),
                              SizedBox(width: 10),
                              Image.asset("lib/assets/images/icon-arrow.png",
                                  height: 15, width: 15, fit: BoxFit.cover),
                            ],
                          )),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                        )),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute( builder: (context) => EditPage( title: "性别",value: userInfo["bitthday"],type:"radio")));
                          },
                          child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("性别"),
                              flex: 1,
                            ),
                            Text(userInfo["birthday"]),
                            SizedBox(width: 10),
                            Image.asset("lib/assets/images/icon-arrow.png",
                                height: 15, width: 15, fit: BoxFit.cover),
                          ],
                        ),
                      )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 20,
                  height: 60,
                  child: FlatButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      _showDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("退出登录",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1))),
                    ),
                  ),
                )
              ],
            )));
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
