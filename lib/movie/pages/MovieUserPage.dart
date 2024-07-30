import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/constant.dart';
import '../provider/UserInfoProvider.dart';
import 'LoginPage.dart';
import 'EditPage.dart';
import '../model/UserInfoModel.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeStyle.dart';
import '../service/serverMethod.dart';
import '../../utils/common.dart';

class MovieUserPage extends StatefulWidget {
  @override
  _MovieUserPageState createState() => _MovieUserPageState();
}

class _MovieUserPageState extends State<MovieUserPage> {
  UserInfoModel userInfo;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController telController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController signController = new TextEditingController();
  TextEditingController regionController = new TextEditingController();

  ///@author: wuwenqiang
  ///@description: 修改用户信息弹窗
  /// @date: 2024-07-30 22:58
  useDialog(TextEditingController controller, String text, String name,
      bool isRequire) {
    controller.text = text;
    showCustomDialog(
        context,
        Scaffold(
            body: Column(children: [
          Center(child: Text('修改$name')),
          Row(
            children: [
              Text(name),
              SizedBox(width: ThemeSize.smallMargin),
              Expanded(
                  flex: 1,
                  child: TextField(
                      controller: controller,
                      cursorColor: Colors.grey, //设置光标
                      decoration: InputDecoration(
                        hintText: '请输入$name',
                        hintStyle: TextStyle(
                            fontSize: ThemeSize.smallFontSize,
                            color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(bottom: ThemeSize.smallMargin),
                      )))
            ],
          )
        ])),
        name,
        () {});
  }

  ///@author: wuwenqiang
  ///@description: 生日
  /// @date: 2024-07-30 22:58
  useDatePicker(){
    int year = 0, month = 0, day = 0;
    List patter = userInfo.birthday != null && userInfo.birthday != ""
        ? userInfo.birthday.split("-")
        : [];
    if (patter.length > 0) {
      year = int.parse(patter[0]);
      month = int.parse(patter[1]);
      day = int.parse(patter[2]);
    } else {
      DateTime dateTime = DateTime.now();
      year = dateTime.year - 20;
      month = dateTime.month;
      day = dateTime.day;
    }
    showDatePicker(
      context: context,
      initialDate: DateTime(year, month, day),
      // 初始化选中日期
      firstDate: DateTime(1900, 6),
      // 开始日期
      lastDate: DateTime.now(),
      // 结束日期
      textDirection: TextDirection.ltr,
      // 文字方向
      helpText: "helpText",
      // 左上方提示
      cancelText: "取消",
      // 取消按钮文案
      confirmText: "确定",
      // 确认按钮文案

      errorFormatText: "errorFormatText",
      // 格式错误提示
      errorInvalidText: "errorInvalidText",
      // 输入不在 first 与 last 之间日期提示

      fieldLabelText: "fieldLabelText",
      // 输入框上方提示
      fieldHintText: "fieldHintText",
      // 输入框为空时内部提示

      initialDatePickerMode: DatePickerMode.day,
      // 日期选择模式，默认为天数选择
      useRootNavigator: true, // 是否为根导航器
    ).then((DateTime date) {
      if (date == null) return;
      setState(() {
        userInfo.birthday = date.year.toString() +
            "-" +
            date.month.toString() +
            "-" +
            date.day.toString();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
            top: true,
            child: Container(
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
                              padding: EdgeInsets.only(
                                  bottom: ThemeSize.containerPadding),
                              child: InkWell(
                                  onTap: () {
                                    _showSelectionDialog(context, 0);
                                  },
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
                                          HOST + userInfo.avater,
                                          height: ThemeSize.bigAvater,
                                          width: ThemeSize.bigAvater,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: ThemeSize.smallMargin),
                                      Image.asset(
                                          "lib/assets/images/icon_arrow.png",
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
                                useDialog(usernameController, userInfo.username,
                                    '昵称', true);
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
                                  Image.asset(
                                      "lib/assets/images/icon_arrow.png",
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
                                    useDialog(usernameController,
                                        userInfo.telephone, '电话', false);
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
                                          "lib/assets/images/icon_arrow.png",
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
                                useDialog(emailController, userInfo.email ?? '',
                                    '邮箱', false);
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
                                  Image.asset(
                                      "lib/assets/images/icon_arrow.png",
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
                                onTap: useDatePicker,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("出生年月日"),
                                      flex: 1,
                                    ),
                                    Text(userInfo.birthday),
                                    SizedBox(width: ThemeSize.smallMargin),
                                    Image.asset(
                                        "lib/assets/images/icon_arrow.png",
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
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => EditPage(
                                  //               title: "性别",
                                  //               value: userInfo.sex,
                                  //               type: "radio",
                                  //               isAllowEmpty: false,
                                  //               field: "sex",
                                  //             )));
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
                                    Image.asset(
                                        "lib/assets/images/icon_arrow.png",
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
                                  useDialog(signController,
                                      userInfo.email ?? '', '签名', false);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("个性签名"),
                                      flex: 1,
                                    ),
                                    Text(userInfo.sign != null
                                        ? userInfo.sign
                                        : ""),
                                    SizedBox(width: ThemeSize.smallMargin),
                                    Image.asset(
                                        "lib/assets/images/icon_arrow.png",
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
                                  useDialog(regionController,
                                      userInfo.region ?? '', '地区', false);
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
                                    Image.asset(
                                        "lib/assets/images/icon_arrow.png",
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
                        borderRadius: BorderRadius.all(
                            Radius.circular(ThemeSize.superRadius)),
                      ),
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: () {
                          showCustomDialog(context, SizedBox(), '确认退出？', () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => route == null);
                          });
                        },
                        child:
                            Text("退出登录", style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ))));
  }

  Future getImage(ImageSource source, int type) async {
    File image = await ImagePicker.pickImage(source: source);
    List<int> imageBytes = await image.readAsBytes();
    String base64Str = "data:image/png;base64," + base64Encode(imageBytes);
    Map avaterMap = {"img": base64Str};
    updateAvaterService(avaterMap).then((res) {
      userInfo.avater = res.data;
      Provider.of<UserInfoProvider>(context, listen: false)
          .setUserInfo(userInfo);
    });
  }

  void _showSelectionDialog(BuildContext context, int type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (ctx) {
        return Container(
          color: Colors.grey,
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      left: ThemeSize.containerPadding,
                      right: ThemeSize.containerPadding),
                  decoration: BoxDecoration(
                    color: ThemeColors.colorWhite,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ThemeSize.middleRadius)),
                  ),
                  child: Column(children: [
                    Container(
                      height: ThemeSize.buttonHeight,
                      child: InkWell(
                        child: _itemCreat(context, '相机'),
                        onTap: () {
                          Navigator.pop(context);
                          getImage(ImageSource.camera, type);
                        },
                      ),
                    ),
                    Container(
                        height: 1,
                        width: double.infinity,
                        color: ThemeColors.colorBg),
                    Container(
                        height: ThemeSize.buttonHeight,
                        child: InkWell(
                          child: _itemCreat(context, '相册'),
                          onTap: () {
                            Navigator.pop(context);
                            getImage(ImageSource.gallery, type);
                          },
                        ))
                  ])),
              InkWell(
                child: Container(
                  margin: EdgeInsets.all(ThemeSize.containerPadding),
                  decoration: BoxDecoration(
                    color: ThemeColors.colorWhite,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ThemeSize.middleRadius)),
                  ),
                  padding: EdgeInsets.all(ThemeSize.containerPadding),
                  child: _itemCreat(context, '取消'),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _itemCreat(BuildContext context, String title) {
    return Center(
        child: Text(
      title,
      style: TextStyle(
          fontSize: ThemeSize.middleFontSize, color: ThemeColors.activeColor),
      textAlign: TextAlign.center,
    ));
  }
}
