import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/UserInfoProvider.dart';
import './provider/TokenProvider.dart';
import './router/index.dart';
import './pages/LaunchPage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TokenProvider("")), //初始化默认值
        ChangeNotifierProvider.value(value: UserInfoProvider(null)), //初始化默认值
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
        home: const LaunchPage());
  }
}
