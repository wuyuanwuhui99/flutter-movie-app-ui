import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../pages/MovieDetailPage.dart';
import '../pages/MovieIndexPage.dart';
import '../model/MovieDetailModel.dart';
import '../pages/MoviePlayerPage.dart';
import '../pages/MovieUserPage.dart';
import '../pages/NewMoviePage.dart';
import '../pages/LoginPage.dart';
import '../pages/ForgetPasswordPage.dart';
import '../pages/NotFoundPage.dart';
import '../pages/ResetPasswordPage.dart';

class Routes {
  static final FluroRouter router = FluroRouter();
  static void initRoutes() {
    /// 指定路由跳转错误返回页
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          debugPrint('未找到目标页');
          return const NotFoundPage();
        });
    router.define('/MovieDetailPage', handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return MovieDetailPage(movieItem: MovieDetailModel.fromJson(json.decode(params["movieItem"]!.first)));
    }));
    router.define('/MovieIndexPage', handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return MovieIndexPage();
    }));
    router.define('/MoviePlayerPage', handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return MoviePlayerPage(movieItem: MovieDetailModel.fromJson(json.decode(params["movieItem"]!.first)));
    }));
    router.define('/MovieUserPage', handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return MovieUserPage();
    }));
    router.define('/NewMoviePage', handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return NewMoviePage(movieItem:  MovieDetailModel.fromJson(json.decode(params["movieItem"]!.first)),);
    }));
  }
}