import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../music/pages/MusicSearchPage.dart';
import '../music/pages/NotFoundPage.dart';
import '../music/pages/MusicPlayerPage.dart';
import '../music/pages/MusicLyricPage.dart';
import '../movie/pages/MoviePlayerPage.dart';
import '../movie/pages/MovieUserPage.dart';
import '../movie/pages/NewMoviePage.dart';
import '../music/pages/MusicIndexPage.dart';

class Routes {
  static final FluroRouter router = FluroRouter();
  static void initRoutes() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          debugPrint('未找到目标页');
          return NotFoundPage();
        });
    router.define('/MusicSearchPage', handler: Handler(handlerFunc: (_, params) {
      return MusicSearchPage();
    }));
    router.define('/MusicPlayerPage', handler: Handler(handlerFunc: (_, params) {
      return MusicPlayerPage();
    }));
    router.define('/MusicLyricPage', handler: Handler(handlerFunc: (_, params) {
      return MusicLyricPage();
    }));
    router.define('/MoviePlayerPage', handler: Handler(handlerFunc: (_, params) {
      return MoviePlayerPage();
    }));
    router.define('/MovieUserPage', handler: Handler(handlerFunc: (_, params) {
      return MovieUserPage();
    }));
    router.define('/NewMoviePage', handler: Handler(handlerFunc: (_, params) {
      return NewMoviePage();
    }));
    router.define('/MusicIndexPage', handler: Handler(handlerFunc: (_, params) {
      return MusicIndexPage();
    }));
  }
}