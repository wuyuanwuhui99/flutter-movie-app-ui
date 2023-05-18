import 'package:flutter/material.dart';
import '../theme/ThemeColors.dart';


class SearchMusicPage extends StatefulWidget {
  final String keyword;

  SearchMusicPage({Key key, this.keyword}) : super(key: key);

  @override
  _SearchMusicPageState createState() => _SearchMusicPageState();
}

class _SearchMusicPageState extends State<SearchMusicPage> {

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
