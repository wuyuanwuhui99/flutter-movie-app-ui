import 'package:flutter/material.dart';
import 'bottom_navigation_widget.dart';
import 'package:provider/provider.dart';
import 'provider/UserInfoProvider.dart';

// void main() => runApp(MyApp());

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserInfoProvider({})), //初始化默认值
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
        theme: ThemeData.light(),
        home: BottomNavigationWidget());
  }
}
