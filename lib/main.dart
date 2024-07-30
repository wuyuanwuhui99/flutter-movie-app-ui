import 'package:flutter/material.dart';
import 'movie/pages/MovieIndexPage.dart';
import 'package:provider/provider.dart';
import './movie/provider/UserInfoProvider.dart';
import './movie/provider/TokenProvider.dart';
import './music/provider/PlayerMusicProvider.dart';
import './movie/model/UserInfoModel.dart';
import './router/index.dart';
import 'movie/pages/LaunchPage.dart';

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
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  MyApp() {
    Routes.initRoutes();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: [MyApp.routeObserver],
        onGenerateRoute: Routes.router.generator,
        title: 'Flutter bottomNavigationBar',
        debugShowCheckedModeBanner:false,
        theme: ThemeData.light(),
        home: LaunchPage());
  }
}
