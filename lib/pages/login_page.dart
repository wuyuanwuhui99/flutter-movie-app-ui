import 'package:flutter/material.dart';
import '../service/server_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/crypto.dart';
import '../bottom_navigation_widget.dart';
import '../provider/UserInfoProvider.dart';
import 'package:provider/provider.dart';
import '../utils/LocalStroageUtils.dart';
import './register_page.dart';
import '../model/UserInfoModel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    String userId = userInfo.userId;
    String password = "123456";
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height:150),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                            color: Color.fromRGBO(237, 237, 237, 1))),
                    child: TextFormField(
                        autovalidate: true,
                        onChanged: (value) {
                          userId = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '请输入用户名';
                          }
                          return null;
                        },
                        initialValue: userId,
                        cursorColor: Colors.grey, //设置光标
                        decoration: InputDecoration(
                          hintText: "请输入用户名",
                          icon: Image.asset("lib/assets/images/icon-user.png",
                              width: 20, height: 20),
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          contentPadding: EdgeInsets.only(left: 0.0),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                            color: Color.fromRGBO(237, 237, 237, 1))),
                    child: TextFormField(
                        autovalidate: true,
                        onChanged: (value) {
                          password = value;
                        },
                        initialValue: "123456",
                        validator: (value) {
                          if (value.isEmpty) {
                            return '请输入密码';
                          }
                          return null;
                        },
                        obscureText: true,
                        cursorColor: Colors.grey, //设置光标
                        decoration: InputDecoration(
                          icon: Image.asset(
                              "lib/assets/images/icon-password.png",
                              width: 20,
                              height: 20),
                          hintText: "请输入密码",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          contentPadding: EdgeInsets.only(left: 0.0),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 20),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border:
                        Border.all(color: Color.fromRGBO(237, 237, 237, 1))),
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      loginService(userId, generateMd5(password)).then((res) async {
                        if (res != null && res["data"] != null) {
                          await LocalStroageUtils.setToken(res["token"]);
                          await Fluttertoast.showToast(
                              msg: "登录成功",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Provider.of<UserInfoProvider>(context)
                              .setUserInfo(UserInfoModel.fromJson(res["data"]));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavigationWidget()));
                        } else {
                          Fluttertoast.showToast(
                              msg: "登录失败，账号或密码错误",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
                    }
                  },
                  child: Text("登录",
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Text("注册"),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border:
                        Border.all(color: Color.fromRGBO(237, 237, 237, 1))),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
