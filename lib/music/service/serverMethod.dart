import 'dart:async';
import 'package:dio/dio.dart';
import 'package:movie/movie/model/CommentModel.dart';
import 'package:movie/music/model/CircleLikeModel.dart';
import '../model/MusicModel.dart';
import '../api/api.dart';
import '../../utils/HttpUtil .dart';

///@author: wuwenqiang
///@description: 获取音乐搜索框关键词
/// @date: 2023-05-18 23:32
Future<ResponseModel<dynamic>> getKeyWordMusicService() async {
  try {
    Response response = await dio.get(servicePath['getKeywordMusic']);
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取音乐分类
/// @date: 2023-05-29 22:57
Future<ResponseModel<List>> getMusicClassifyService() async {
  try {
    Response response = await dio.get(servicePath['getMusicClassify']);
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
/// @params isRedis是否从缓存中获取，首页数据没有是否喜欢字段，不用从缓存中获取，只有推荐页面才有
Future<ResponseModel<List>> getMusicListByClassifyIdService(
    int classifyId, int pageNum, int pageSize, int isRedis) async {
  try {
    Response response = await dio.get(
        "${servicePath['getMusicListByClassifyId']}?classifyId=${classifyId}&pageNum=${pageNum}&pageSize=${pageSize}&isRedis=${isRedis}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
Future<ResponseModel<List>> getSingerListService(
    String category, int pageNum, int pageSize) async {
  try {
    Response response = await dio.get(
        "${servicePath['getSingerList']}?${category != '' && category != null ? "category=" + category + "&" : ""}pageNum=${pageNum}&pageSize=${pageSize}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
Future<ResponseModel<List>> getCircleListByTypeService(
    String type, int pageNum, int pageSize) async {
  try {
    Response response = await dio.get(
        "${servicePath['getCircleListByType']}?type=${type}&pageNum=${pageNum}&pageSize=${pageSize}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取用户歌单
/// @date: 2023-07-08 18:45
Future<ResponseModel<List>> getMusicPlayMenuService() async {
  try {
    Response response = await dio.get(servicePath['getMusicPlayMenu']);
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取我关注的歌手
/// @date: 2023-07-09 11:29
Future<ResponseModel<List>> getMySingerService(
    int pageNum, int pageSize) async {
  try {
    Response response = await dio.get(
        "${servicePath['getMySinger']}?pageNum=${pageNum}&pageSize=${pageSize}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取我关注的歌手
/// @date: 2023-07-09 11:29
Future<ResponseModel<List>> getMusicRecordService(
    int pageNum, int pageSize) async {
  try {
    Response response = await dio.get(
        "${servicePath['getMusicRecord']}?pageNum=${pageNum}&pageSize=${pageSize}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取我关注的歌手
/// @date: 2023-11-20 22:15
Future<ResponseModel<int>> insertMusicRecordService(
    MusicModel musicModel) async {
  try {
    Response response = await dio.post(servicePath['insertMusicRecord'],
        data: MusicModel.toMap(musicModel));
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 插入收藏
/// @date: 2024-01-05 22:26
Future<ResponseModel<int>> insertMusicFavoriteService(
    MusicModel musicModel) async {
  try {
    Response response = await dio.post(servicePath['insertMusicFavorite'],
        data: MusicModel.toMap(musicModel));
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 删除收藏
/// @date: 2024-01-05 23:44
Future<ResponseModel<int>> deleteMusicFavoriteService(int id) async {
  try {
    Response response =
        await dio.delete(servicePath['deleteMusicFavorite'] + id.toString());
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 删除收藏
/// @date: 2024-01-05 23:44
Future<ResponseModel<List>> queryMusicFavoriteService(
    int pageNum, int pageSize) async {
  try {
    Response response = await dio.get(
        "${servicePath['queryMusicFavorite']}?pageNum=${pageNum}&pageSize=${pageSize}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 搜索
/// @date: 2024-01-27 16:46
Future<ResponseModel<List>> searchMusicService(
    String keyword, int pageNum, int pageSize) async {
  try {
    Response response = await dio.get(
        "${servicePath['searchMusic']}?keyword=${keyword}&pageNum=${pageNum.toString()}&pageSize=${pageSize.toString()}");
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 获取歌手分类
/// @date: 2024-02-27 22:51
Future<ResponseModel<List>> getSingerCategoryService() async {
  try {
    Response response = await dio.get(servicePath['getSingerCategory']);
    return ResponseModel<List>.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 点赞
/// @date: 2024-3-28 22:10
Future<ResponseModel> saveLikeService(CircleLikeModel circleLikeModel) async {
  try {
    Response response =
        await dio.post(servicePath['saveLike'], data: circleLikeModel.toMap());
    return ResponseModel.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}

///@author: wuwenqiang
///@description: 点赞
/// @date: 2024-3-28 22:10
Future<ResponseModel<int>> deleteLikeService(
    int relationId, String type) async {
  try {
    Response response = await dio.delete(
        '${servicePath['deleteLike']}?relationId=${relationId.toString()}&type=${type.toString()}');
    return ResponseModel<int>.fromJson(response.data);
  } catch (e) {
    print('ERROR:======>${e}');
    return null;
  }
}