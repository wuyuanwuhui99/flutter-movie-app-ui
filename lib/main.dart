import 'package:flutter/material.dart';
import 'BottomNavigationWidget.dart';
import 'package:provider/provider.dart';
import 'provider/UserInfoProvider.dart';
import 'model/UserInfoModel.dart';

// void main() => runApp(MyApp());

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserInfoProvider(UserInfoModel.fromJson({}))), //初始化默认值
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter bottomNavigationBar',
        debugShowCheckedModeBanner:false,

        theme: ThemeData.light(),
        home: BottomNavigationWidget());
  }
}
