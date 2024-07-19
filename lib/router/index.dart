import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../movie/model/MovieDetailModel.dart';
import '../music/model/FavoriteDirectoryModel.dart';
import '../music/model/MusicModel.dart';
import '../music/pages/MusicFavoriteListPage.dart';
import '../music/pages/MusicSearchPage.dart';
import '../music/pages/NotFoundPage.dart';
import '../music/pages/MusicPlayerPage.dart';
import '../music/pages/MusicLyricPage.dart';
import '../movie/pages/MoviePlayerPage.dart';
import '../movie/pages/MovieUserPage.dart';
import '../movie/pages/NewMoviePage.dart';
import '../music/pages/MusicIndexPage.dart';
import '../music/pages/MusicSingerPage.dart';
import '../music/pages/MusicSharePage.dart';

class Routes {
  static final FluroRouter router = FluroRouter();
  static void initRoutes() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          debugPrint('未找到目标页');
          return NotFoundPage();
        });
    router.define('/MusicSearchPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicSearchPage(keyword:params['keyword'].first);
    }));
    router.define('/MusicPlayerPage', handler: Handler(handlerFunc: (BuildContext context, params) {
      return MusicPlayerPage();
    }));
    router.define('/MusicLyricPage', handler: Handler(handlerFunc: (BuildContext context, Map<String,List<String>> params) {
      return MusicLyricPage();
    }));
    router.define('/MoviePlayerPage', handler: Handler(handlerFunc: (BuildContext context,Map<String, List<String>> params) {
      return MoviePlayerPage(movieItem: MovieDetailModel.fromJson(json.decode(params["movieItem"].first)));
    }));
    router.define('/MovieUserPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MovieUserPage();
    }));
    router.define('/NewMoviePage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>>params) {
      return NewMoviePage();
    }));
    router.define('/MusicIndexPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicIndexPage();
    }));
    router.define('/MusicSingerPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicSingerPage();
    }));
    router.define('/MusicSharePage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicSharePage(musicModel:MusicModel.fromJson(jsonDecode(params['musicItem'].first)));
    }));
    router.define('/MusicFavoriteListPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicFavoriteListPage(favoriteDirectoryModel:FavoriteDirectoryModel.fromJson(jsonDecode(params['favoriteDirectoryModel'].first)));
    }));
  }
}