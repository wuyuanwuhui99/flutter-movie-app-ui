import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import '../router/index.dart';
import '../service/serverMethod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../component/NavigatorTitleComponent.dart';

class ForgetPasswordPage extends StatelessWidget {
  bool loading = false;
  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: "405873717@qq.com");
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const NavigatorTitleComponent(title: "忘记密码"),
                SizedBox(height: ThemeSize.containerPadding),
                Column(
                  children: [
                    Container(
                        decoration: ThemeStyle.boxDecoration,
                        margin: ThemeStyle.paddingBox,
                        padding: ThemeStyle.paddingBox,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("*",
                                style: TextStyle(color: ThemeColors.warnColor)),
                            Expanded(
                                flex: 1,
                                child: TextField(
                                    controller: emailController,
                                    cursorColor: Colors.grey,
                                    //设置光标
                                    decoration: InputDecoration(
                                      hintText: "请输入邮箱",
                                      hintStyle: TextStyle(
                                          fontSize: ThemeSize.smallFontSize,
                                          color: Colors.grey),
                                      contentPadding: EdgeInsets.only(
                                          left: ThemeSize.containerPadding),
                                      border: InputBorder.none,
                                    )))
                          ],
                        )),
                    SizedBox(height: ThemeSize.containerPadding),
                    Container(
                        margin: ThemeStyle.paddingBox,
                        child: InkWell(
                          onTap: () {
                            if(loading)return;
                            if(emailController.text == ""){
                              Fluttertoast.showToast(
                                  msg: '请输入邮箱',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            }else{
                              loading = true;
                              getBackPasswordService(emailController.text)
                                  .then((res) async {
                                    loading = false;
                                if (res.data as int > 0) {
                                  await Fluttertoast.showToast(
                                      msg: res.msg as String,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: ThemeSize.middleFontSize);
                                  Routes.router.navigateTo(context,
                                      '/ResetPasswordPage?email=${Uri.encodeComponent(json.encode(emailController.text))}');
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "验证码发送失败",
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
