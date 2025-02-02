import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import '../common/config.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../common/constant.dart';
import '../provider/UserInfoProvider.dart';
import '../router/index.dart';
import 'LoginPage.dart';
import '../model/UserInfoModel.dart';
import '../theme/ThemeColors.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeStyle.dart';
import '../service/serverMethod.dart';
import '../utils/common.dart';
import '../component/NavigatorTitleComponent.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  TextEditingController usernameController = TextEditingController(); // 姓名
  TextEditingController telController = TextEditingController(); // 电话
  TextEditingController emailController = TextEditingController(); // 邮箱
  TextEditingController signController = TextEditingController(); // 签名
  TextEditingController regionController = TextEditingController(); // 地区
  late UserInfoProvider provider;
  bool hasChange = false;
  bool loading = false;

  ///@author: wuwenqiang
  ///@description: 修改用户信息弹窗
  /// @date: 2024-07-30 22:58
  useDialog(TextEditingController controller, String text, String name,
      String field, bool isRequire) {
    controller.text = text;
    showCustomDialog(
        context,
        Row(
          children: [
            Text(name),
            SizedBox(width: ThemeSize.smallMargin),
            Expanded(
                flex: 1,
                child: Card(
                    color: ThemeColors.disableColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ThemeSize.middleRadius),
                    ),
                    elevation: 0,
                    child: TextField(
                        onChanged: (value) {
                          hasChange = value != text;
                        },
                        textAlignVertical: TextAlignVertical.top,
                        controller: controller,
                        cursorColor: Colors.grey,
                        //设置光标
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: ThemeSize.miniMargin),
                          hintText: '请输入$name',
                          hintStyle: TextStyle(
                              fontSize: ThemeSize.smallFontSize,
                              color: Colors.grey),
                          border: InputBorder.none,
                        ))))
          ],
        ),
        name, () {
      useSave(controller.text, name, field, isRequire);
    });
  }

  void useSave(dynamic value, String name, String field, bool isRequire) {
    if (!hasChange || loading) return;
    loading = true;
    if (isRequire && value == "") {
      Fluttertoast.showToast(
          msg: "${name}不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: ThemeSize.middleFontSize);
      loading = false;
    } else {
      // await EasyLoading.show();
      Map myUserInfo = provider.userInfo.toMap();
      myUserInfo[field] = value;
      updateUserData(myUserInfo).then((value) async {
        hasChange = false;
        provider.setUserInfo(UserInfoModel.fromJson(myUserInfo));
        // await EasyLoading.dismiss(animation: true);
        Navigator.pop(context);
        loading = false;
      }).catchError(() {
        loading = false;
      });
    }
  }

  ///@author: wuwenqiang
  ///@description: 生日
  /// @date: 2024-07-30 22:58
  useDatePicker() {
    int year = 0, month = 0, day = 0;
    List patter =
        provider.userInfo.birthday != null && provider.userInfo.birthday != ""
            ? provider.userInfo.birthday.split("-")
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
    // showDatePicker(
    //   context: context,
    //   initialDate: DateTime(year, month, day),
    //   // 初始化选中日期
    //   firstDate: DateTime(1900, 6),
    //   // 开始日期
    //   lastDate: DateTime.now(),
    //   // 结束日期
    //   textDirection: TextDirection.ltr,
    //   // 文字方向
    //   helpText: "helpText",
    //   // 左上方提示
    //   cancelText: "取消",
    //   // 取消按钮文案
    //   confirmText: "确定",
    //   // 确认按钮文案
    //
    //   errorFormatText: "errorFormatText",
    //   // 格式错误提示
    //   errorInvalidText: "errorInvalidText",
    //   // 输入不在 first 与 last 之间日期提示
    //
    //   fieldLabelText: "fieldLabelText",
    //   // 输入框上方提示
    //   fieldHintText: "fieldHintText",
    //   // 输入框为空时内部提示
    //
    //   initialDatePickerMode: DatePickerMode.day,
    //   // 日期选择模式，默认为天数选择
    //   useRootNavigator: true, // 是否为根导航器
    // ).then((DateTime date) {
    //   if (date == null) return;
    //   String value =
    //       "${date.year.toString()}-${date.month.toString()}-${date.day.toString()}";
    //   hasChange = true;
    //   useSave(value, '出生年月','birthday' ,false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<UserInfoProvider>(context, listen: true);
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
            top: true,
            child: Container(
                width: double.infinity,
                height: double.infinity,
                // padding: ThemeStyle.paddingBox,
                child: Column(
                  children: <Widget>[
                    const NavigatorTitleComponent(title: "修改用户信息"),
                    Expanded(
                        flex: 1,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: ThemeStyle.padding,
                          children: [
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
                                            // showSelectionDialog(["相机", "相册"],
                                            //     (String value) {
                                            //   getImage(value == "相机"
                                            //       ? getImage(ImageSource.camera)
                                            //       : ImageSource.gallery);
                                            // });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text("头像"),
                                                flex: 1,
                                              ),
                                              ClipOval(
                                                child: Image.network(
                                                  //从全局的provider中获取用户信息
                                                  HOST +
                                                      provider.userInfo.avater,
                                                  height: ThemeSize.bigAvater,
                                                  width: ThemeSize.bigAvater,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: ThemeSize.smallMargin),
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
                                        useDialog(
                                            usernameController,
                                            provider.userInfo.username,
                                            '昵称',
                                            'username',
                                            true);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text("昵称"),
                                            flex: 1,
                                          ),
                                          Text(provider.userInfo.username),
                                          SizedBox(
                                              width: ThemeSize.smallMargin),
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
                                            useDialog(
                                                usernameController,
                                                provider.userInfo.telephone,
                                                '电话',
                                                'telephone',
                                                false);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text("电话"),
                                                flex: 1,
                                              ),
                                              Text(provider.userInfo.telephone),
                                              SizedBox(
                                                  width: ThemeSize.smallMargin),
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
                                        useDialog(
                                            emailController,
                                            provider.userInfo.email ?? '',
                                            '邮箱',
                                            'email',
                                            false);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text("邮箱"),
                                            flex: 1,
                                          ),
                                          Text(provider.userInfo.email),
                                          SizedBox(
                                              width: ThemeSize.smallMargin),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text("出生年月日"),
                                              flex: 1,
                                            ),
                                            Text(provider.userInfo.birthday ??
                                                ""),
                                            SizedBox(
                                                width: ThemeSize.smallMargin),
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
                                          showSelectionDialog(["男", "女"],
                                              (String value) {
                                            hasChange = true;
                                            useSave(SexNameMap[value], 'sex',
                                                '性别', false);
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Expanded(
                                              flex: 1,
                                              child: Text("性别"),
                                            ),
                                            Text(provider.userInfo.sex != null
                                                ? SexValueMap[
                                                    provider.userInfo.sex]!
                                                : ''),
                                            SizedBox(
                                                width: ThemeSize.smallMargin),
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
                                          useDialog(
                                              signController,
                                              provider.userInfo.sign ?? '',
                                              '签名',
                                              'sign',
                                              false);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text("个性签名"),
                                              flex: 1,
                                            ),
                                            Text(provider.userInfo.sign ?? ""),
                                            SizedBox(
                                                width: ThemeSize.smallMargin),
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
                                          useDialog(
                                              regionController,
                                              provider.userInfo.region ?? '',
                                              '地区',
                                              'region',
                                              false);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text("地区"),
                                              flex: 1,
                                            ),
                                            Text(
                                                provider.userInfo.region ?? ""),
                                            SizedBox(
                                                width: ThemeSize.smallMargin),
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
                              margin: EdgeInsets.only(
                                  top: ThemeSize.containerPadding),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ThemeSize.superRadius)),
                              ),
                              width: double.infinity,
                              child: MaterialButton(
                                onPressed: () {
                                  showCustomDialog(context, SizedBox(), '确认退出？',
                                      () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (route) => route == null);
                                  });
                                },
                                child: const Text("退出登录",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Routes.router.navigateTo(context, '/UpdatePasswordPage',
                                      replace: false);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top:ThemeSize.containerPadding),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(ThemeSize.superRadius)),
                                        border:
                                        Border.all(color: ThemeColors.borderColor)),
                                    width: double.infinity,
                                    height: ThemeSize.buttonHeight,
                                    child: const Center(child: Text("修改密码")))),
                          ],
                        ))
                  ],
                ))));
  }

  Future getImage(ImageSource source) async {
    // File image = await ImagePicker.pickImage(source: source);
    // List<int> imageBytes = await image.readAsBytes();
    // String base64Str = "data:image/png;base64," + base64Encode(imageBytes);
    // Map avaterMap = {"img": base64Str};
    // updateAvaterService(avaterMap).then((res) {
    //   provider.userInfo.avater = res.data;
    //   provider.setUserInfo(provider.userInfo);
    // });
  }

  ///@author: wuwenqiang
  ///@description: 底部弹出选项
  /// @date: 2024-07-31 23:07
  void showSelectionDialog(List<String> options, Function onTap) {
    List<Widget> optionWidgetList = [];
    int index = -1;
    options.forEach((element) {
      index++;
      optionWidgetList.add(Container(
        height: ThemeSize.buttonHeight,
        child: InkWell(
          child: _itemCreat(context, element),
          onTap: () {
            Navigator.pop(context);
            onTap(element);
          },
        ),
      ));
      if (index != options.length) {
        optionWidgetList.add(Container(
            height: 1, width: double.infinity, color: ThemeColors.colorBg));
      }
    });
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
                  child: Column(children: optionWidgetList)),
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
