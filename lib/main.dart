import 'package:flutter/material.dart';
import 'BottomNavigationWidget.dart';
import 'package:provider/provider.dart';
import './movie/provider/UserInfoProvider.dart';
import './movie/provider/TokenProvider.dart';
import './music/provider/PlayerMusicProvider.dart';
import './movie/model/UserInfoModel.dart';
import './router/index.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TokenProvider("")), //初始化默认值
        ChangeNotifierProvider.value(value: UserInfoProvider(UserInfoModel.fromJson({}))), //初始化默认值
        ChangeNotifierProvider.value(value: PlayerMusicProvider(null)), //初始化默认值
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp() {
    Routes.initRoutes();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: Routes.router.generator,
        title: 'Flutter bottomNavigationBar',
        debugShowCheckedModeBanner:false,
        theme: ThemeData.light(),
        home: BottomNavigationWidget());
  }
}
