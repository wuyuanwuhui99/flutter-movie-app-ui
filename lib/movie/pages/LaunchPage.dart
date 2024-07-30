import 'package:flutter/material.dart';
import '../../router/index.dart';
import '../service/serverMethod.dart';
import '../../utils/HttpUtil.dart';
import '../provider/UserInfoProvider.dart';
import 'package:provider/provider.dart';
import '../../utils/LocalStorageUtils.dart';
import '../model/UserInfoModel.dart';

class LaunchPage extends StatefulWidget {
  LaunchPage({Key key}):super(key: key);

  @override
  LaunchPageState createState() => LaunchPageState();
}

class LaunchPageState extends State<LaunchPage> {

  @override
  void initState() {
    LocalStorageUtils.getToken().then((res){
      Future.delayed(const Duration(seconds: 1), () {
        // 这里是你想要延时执行的代码
        HttpUtil.getInstance().setToken(res);
        if(res != ''){// 已经登录
          getUserDataService().then((data){
            if(data.token != null){
              String token = data.token;
              LocalStorageUtils.setToken(token);
              HttpUtil.getInstance().setToken(token);
              Provider.of<UserInfoProvider>(context,listen: false).setUserInfo(UserInfoModel.fromJson(data.data));
            }
            Routes.router.navigateTo(context, '/MovieIndexPage',replace: true);
          });
        }else{// 没有登录
          Routes.router.navigateTo(context, '/LoginPage',replace: true);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:Center(child: Text('欢迎使用')),
          ),
        ));
  }
}
