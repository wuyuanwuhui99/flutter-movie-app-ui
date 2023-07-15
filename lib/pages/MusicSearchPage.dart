import 'package:flutter/material.dart';
import '../theme/ThemeColors.dart';


class MusicSearchPage extends StatefulWidget {
  final String keyword;

  MusicSearchPage({Key key, this.keyword}) : super(key: key);

  @override
  _SearchMusicPageState createState() => _SearchMusicPageState();
}

class _SearchMusicPageState extends State<MusicSearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
          top: true,
          child: Text("搜索"),
          ),
        );
  }
}
