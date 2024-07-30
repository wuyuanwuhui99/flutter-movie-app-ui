import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/crypto.dart';
import 'MovieIndexPage.dart';
import '../provider/UserInfoProvider.dart';
import 'package:provider/provider.dart';
import '../../utils/LocalStorageUtils.dart';
import 'RegisterPage.dart';
import '../model/UserInfoModel.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    String userId = userInfo.userId;
    TextEditingController userController =
        new TextEditingController(text: userInfo.userId);
    TextEditingController pwdController =
        new TextEditingController(text: "123456");
    String password = "123456";
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
          child: Container(
            padding: ThemeStyle.padding,
            margin: ThemeStyle.padding,
            decoration: ThemeStyle.boxDecoration,
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        "lib/assets/images/icon_logo.png",
                        width: ThemeSize.movieWidth / 2,
                        height: ThemeSize.movieWidth / 2,
                      )),
                      SizedBox(
                        height: ThemeSize.containerPadding * 2,
                      ),
                      Container(
                          margin: ThemeStyle.margin,
                          padding:
                              EdgeInsets.only(left: ThemeSize.containerPadding),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ThemeSize.superRadius)),
                              border:
                                  Border.all(color: ThemeColors.borderColor)),
                          child: TextField(
                              onChanged: (value) {
                                if (value != "") {
                                  userId = value;
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "请输入用户名",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: 1,
                                      backgroundColor: ThemeColors.disableColor,
                                      fontSize: ThemeSize.middleFontSize);
                                }
                              },
                              controller: userController,
                              cursorColor: Colors.grey, //设置光标
                              decoration: InputDecoration(
                                hintText: "请输入用户名",
                                icon: Image.asset(
                                    "lib/assets/images/icon_user.png",
                                    width: ThemeSize.smallIcon,
                                    height: ThemeSize.smallIcon),
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                contentPadding: EdgeInsets.only(left: 0.0),
                                border: InputBorder.none,
                              ))),
                      Container(
                          padding:
                              EdgeInsets.only(left: ThemeSize.containerPadding),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ThemeSize.superRadius)),
                              border:
                                  Border.all(color: ThemeColors.borderColor)),
                          child: TextField(
                              onChanged: (value) {
                                if (value != "") {
                                  password = value;
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "请输入用户名",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: 1,
                                      backgroundColor: ThemeColors.disableColor,
                                      fontSize: ThemeSize.middleFontSize);
                                }
                              },
                              controller: pwdController,
                              obscureText: true,
                              cursorColor: Colors.grey,
                              //设置光标
                              decoration: InputDecoration(
                                icon: Image.asset(
                                    "lib/assets/images/icon_password.png",
                                    width: ThemeSize.smallIcon,
                                    height: ThemeSize.smallIcon),
                                hintText: "请输入密码",
                                hintStyle: TextStyle(
                                    fontSize: ThemeSize.smallFontSize,
                                    color: Colors.grey),
                                contentPadding: EdgeInsets.only(left: 0.0),
                                border: InputBorder.none,
                              ))),
                      SizedBox(height: ThemeSize.containerPadding),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ThemeSize.superRadius)),
                      ),
                      width: double.infinity,
                      child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              loginService(userId, generateMd5(password))
                                  .then((res) async {
                                if (res != null && res.data != null) {
                                  await LocalStorageUtils.setToken(res.token);
                                  await Fluttertoast.showToast(
                                      msg: "登录成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: ThemeSize.middleFontSize);
                                  Provider.of<UserInfoProvider>(context,
                                          listen: false)
                                      .setUserInfo(
                                          UserInfoModel.fromJson(res.data));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MovieIndexPage()));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "登录失败，账号或密码错误",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: ThemeSize.middleFontSize);
                                }
                              });
                            }
                          },
                          child: Text("登录",
                              style: TextStyle(color: ThemeColors.colorWhite))),
                    ),
                    SizedBox(height: ThemeSize.containerPadding),
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(ThemeSize.superRadius)),
                          border: Border.all(color: ThemeColors.borderColor)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
