import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../music/pages/MusicCategoryPage.dart';
import '../movie/pages/MovieDetailPage.dart';
import '../music/model/MusicAuthorModel.dart';
import '../music/pages/MusicAuthorListPage.dart';
import '../movie/pages/MovieIndexPage.dart';
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
import '../music/pages/MusicAuthorCategoryPage.dart';
import '../music/pages/MusicSharePage.dart';
import '../music/pages/MusicClassifyListPage.dart';
import '../music/model/MusicClassifyModel.dart';

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
    router.define('/MovieDetailPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MovieDetailPage(movieItem: MovieDetailModel.fromJson(json.decode(params["movieItem"].first)));
    }));
    router.define('/MovieIndexPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MovieIndexPage();
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
    router.define('/MusicAuthorCategoryPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicAuthorCategoryPage();
    }));
    router.define('/MusicSharePage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicSharePage(musicModel:MusicModel.fromJson(jsonDecode(params['musicItem'].first)));
    }));
    router.define('/MusicFavoriteListPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicFavoriteListPage(favoriteDirectoryModel:FavoriteDirectoryModel.fromJson(jsonDecode(params['favoriteDirectoryModel'].first)));
    }));
    router.define('/MusicClassifyListPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicClassifyListPage(musicClassifyModel:MusicClassifyModel.fromJson(jsonDecode(params['musicClassifyModel'].first)));
    }));
    router.define('/MusicAuthorListPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicAuthorListPage(authorMode:MusicAuthorModel.fromJson(jsonDecode(params['authorModel'].first)));
    }));
    router.define('/MusicCategoryPage', handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MusicCategoryPage();
    }));

  }
}