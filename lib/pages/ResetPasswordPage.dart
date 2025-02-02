import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/UserInfoModel.dart';
import 'package:provider/provider.dart';
import '../provider/UserInfoProvider.dart';
import '../router/index.dart';
import '../service/serverMethod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../component/NavigatorTitleComponent.dart';
import '../utils/LocalStorageUtils.dart';

class ResetPasswordPage extends StatelessWidget {
  final String email;
  ResetPasswordPage({super.key,required this.email});
  TextEditingController codeController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController comfirmPasswordController = TextEditingController(text: "");
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const NavigatorTitleComponent(title: "重置密码"),
                SizedBox(height: ThemeSize.containerPadding),
                Column(
                  children: [
                    Container(
                        decoration: ThemeStyle.boxDecoration,
                        margin: ThemeStyle.paddingBox,
                        padding: ThemeStyle.paddingBox,
                        child:
                        Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("*",
                                  style: TextStyle(color: ThemeColors.warnColor)),
                              Expanded(
                                  flex: 1,
                                  child: TextField(
                                      controller: codeController,
                                      cursorColor: Colors.grey,
                                      //设置光标
                                      decoration: InputDecoration(
                                        hintText: "请输入邮箱验证码",
                                        hintStyle: TextStyle(
                                            fontSize: ThemeSize.smallFontSize,
                                            color: Colors.grey),
                                        contentPadding: EdgeInsets.only(
                                            left: ThemeSize.containerPadding),
                                        border: InputBorder.none,
                                      )))
                            ],
                          ),
                          Divider(height: 1,color:ThemeColors.borderColor),
                          SizedBox(height: ThemeSize.containerPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("*",
                                  style: TextStyle(color: ThemeColors.warnColor)),
                              Expanded(
                                  flex: 1,
                                  child: TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      cursorColor: Colors.grey,
                                      //设置光标
                                      decoration: InputDecoration(
                                        hintText: "请输入新密码",
                                        hintStyle: TextStyle(
                                            fontSize: ThemeSize.smallFontSize,
                                            color: Colors.grey),
                                        contentPadding: EdgeInsets.only(
                                            left: ThemeSize.containerPadding),
                                        border: InputBorder.none,
                                      )))
                            ],
                          ),
                          Divider(height: 1,color:ThemeColors.borderColor),
                          SizedBox(height: ThemeSize.containerPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("*",
                                  style: TextStyle(color: ThemeColors.warnColor)),
                              Expanded(
                                  flex: 1,
                                  child: TextField(
                                      controller: comfirmPasswordController,
                                      obscureText: true,
                                      cursorColor: Colors.grey,
                                      //设置光标
                                      decoration: InputDecoration(
                                        hintText: "请输入新确认密码",
                                        hintStyle: TextStyle(
                                            fontSize: ThemeSize.smallFontSize,
                                            color: Colors.grey),
                                        contentPadding: EdgeInsets.only(
                                            left: ThemeSize.containerPadding),
                                        border: InputBorder.none,
                                      )))
                            ],
                          )
                        ],)
                        ),
                    SizedBox(height: ThemeSize.containerPadding),
                    Container(
                        margin: ThemeStyle.paddingBox,
                        child: InkWell(
                          onTap: () {
                            if(codeController.text == ""){
                              Fluttertoast.showToast(
                                  msg: '请输入邮箱验证码',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            }else if(passwordController.text == ""){
                              Fluttertoast.showToast(
                              msg: '请输入新密码',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: ThemeSize.middleFontSize);
                            }else if(comfirmPasswordController.text == ""){
                              Fluttertoast.showToast(
                                  msg: '请输入新确认密码',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            }else if(comfirmPasswordController.text != passwordController.text){
                              Fluttertoast.showToast(
                                  msg: '请输入新密码和新确认密码',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            }else{
                              loading = true;
                              resetPasswordService(email,passwordController.text,codeController.text,)
                                  .then((res) async {
                                loading = false;
                                if (res.data != null) {
                                  await LocalStorageUtils.setToken(res.token!);
                                  await Fluttertoast.showToast(
                                      msg: '重置密码成功',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: ThemeSize.middleFontSize);
                                  Provider.of<UserInfoProvider>(context,
                                      listen: false)
                                      .setUserInfo(
                                      UserInfoModel.fromJson(res.data));
                                  Routes.router.navigateTo(
                                      context, '/MusicIndexPage',
                                      replace: true);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "重置密码失败",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: ThemeSize.middleFontSize);
                                }
                              });
                            }
                          },
                          child: Container(
                            height: ThemeSize.buttonHeight,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ThemeSize.superRadius)),
                            ),
                            width: double.infinity,
                            child: Center(
                                child: Text("提交",
                                    style: TextStyle(
                                        color: ThemeColors.colorWhite))),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
