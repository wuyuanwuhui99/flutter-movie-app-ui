import 'package:flutter/material.dart';
import '../theme/ThemeColors.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: const Text('找不到页面'));
  }
}
