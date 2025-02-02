import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../component/NavigatorTitleComponent.dart';

class UpdatePasswordPage extends StatelessWidget {
  bool loading = false;

  UpdatePasswordPage({super.key});

  TextEditingController oldPasswordController = TextEditingController(text: "");
  TextEditingController newPasswordController = TextEditingController(text: "");
  TextEditingController comfirmController = TextEditingController(text: "");

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
                const NavigatorTitleComponent(title: "忘记密码"),
                SizedBox(height: ThemeSize.containerPadding),
                Column(
                  children: [
                    Container(
                        decoration: ThemeStyle.boxDecoration,
                        margin: ThemeStyle.paddingBox,
                        padding: ThemeStyle.paddingBox,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("*",
                                    style: TextStyle(
                                        color: ThemeColors.warnColor)),
                                Expanded(
                                    flex: 1,
                                    child: TextField(
                                        obscureText: true,
                                        controller: oldPasswordController,
                                        cursorColor: Colors.grey,
                                        //设置光标
                                        decoration: InputDecoration(
                                          hintText: "请输入旧密码",
                                          hintStyle: TextStyle(
                                              fontSize: ThemeSize.smallFontSize,
                                              color: Colors.grey),
                                          contentPadding: EdgeInsets.only(
                                              left: ThemeSize.containerPadding),
                                          border: InputBorder.none,
                                        )))
                              ],
                            ),
                            Divider(height: 1, color: ThemeColors.borderColor),
                            SizedBox(height: ThemeSize.containerPadding),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("*",
                                    style: TextStyle(
                                        color: ThemeColors.warnColor)),
                                Expanded(
                                    flex: 1,
                                    child: TextField(
                                        obscureText: true,
                                        controller: newPasswordController,
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
                            Divider(height: 1, color: ThemeColors.borderColor),
                            SizedBox(height: ThemeSize.containerPadding),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("*",
                                    style: TextStyle(
                                        color: ThemeColors.warnColor)),
                                Expanded(
                                    flex: 1,
                                    child: TextField(
                                        obscureText: true,
                                        controller: comfirmController,
                                        cursorColor: Colors.grey,
                                        //设置光标
                                        decoration: InputDecoration(
                                          hintText: "请输入确认密码",
                                          hintStyle: TextStyle(
                                              fontSize: ThemeSize.smallFontSize,
                                              color: Colors.grey),
                                          contentPadding: EdgeInsets.only(
                                              left: ThemeSize.containerPadding),
                                          border: InputBorder.none,
                                        )))
                              ],
                            ),
                          ],
                        )),
                    SizedBox(height: ThemeSize.containerPadding),
                    Container(
                        margin: ThemeStyle.paddingBox,
                        child: InkWell(
                          onTap: () {
                            if (loading) return;
                            if (oldPasswordController.text == "") {
                              Fluttertoast.showToast(
                                  msg: '请输入旧密码',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: ThemeColors.subTitle,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            } else if (newPasswordController.text == "") {
                              Fluttertoast.showToast(
                                  msg: '请输入新密码',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: ThemeColors.subTitle,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            } else if (comfirmController.text == "") {
                              Fluttertoast.showToast(
                                  msg: '请输入确认密码',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: ThemeColors.subTitle,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            } else if (comfirmController.text !=
                                newPasswordController.text) {
                              Fluttertoast.showToast(
                                  msg: '新密码和确认密码不椅子',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: ThemeColors.subTitle,
                                  textColor: Colors.white,
                                  fontSize: ThemeSize.middleFontSize);
                            } else {
                              loading = true;
                              updatePasswordService(oldPasswordController.text,
                                      newPasswordController.text)
                                  .then((res) async {
                                loading = false;
                                if (res.data > 0) {
                                  await Fluttertoast.showToast(
                                      msg: res.msg as String,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: ThemeColors.subTitle,
                                      textColor: Colors.white,
                                      fontSize: ThemeSize.middleFontSize);
                                  Navigator.of(context).pop();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "更新密码失败",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: ThemeColors.subTitle,
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
