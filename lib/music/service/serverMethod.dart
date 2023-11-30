import 'dart:async';
import 'package:dio/dio.dart';
import '../model/MusicModel.dart';
import '../api/api.dart';
import '../../utils/HttpUtil .dart';


///@author: wuwenqiang
///@description: 获取音乐搜索框关键词
/// @date: 2023-05-18 23:32
Future getKeyWordMusicService() async {
  try {
    Response response = await dio.get(servicePath['getKeywordMusic']);
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取音乐分类
/// @date: 2023-05-29 22:57
Future getMusicClassifyService() async {
  try {
    Response response = await dio.get(servicePath['getMusicClassify']);
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
/// @params isRedis是否从缓存中获取，首页数据没有是否喜欢字段，不用从缓存中获取，只有推荐页面才有
Future getMusicListByClassifyIdService(int classifyId,int pageNum,int pageSize,int isRedis) async {
  try {
    Response response = await dio.get("${servicePath['getMusicListByClassifyId']}?classifyId=${classifyId}&pageNum=${pageNum}&pageSize=${pageSize}&isRedis=${isRedis}");
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
Future getSingerListService(int pageNum,int pageSize) async {
  try {
    Response response = await dio.get("${servicePath['getSingerList']}?pageNum=${pageNum}&pageSize=${pageSize}");
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
Future getCircleListByTypeService(String type,int pageNum,int pageSize) async {
  try {
    Response response = await dio.get("${servicePath['getCircleListByType']}?type=${type}&pageNum=${pageNum}&pageSize=${pageSize}");
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取用户歌单
/// @date: 2023-07-08 18:45
Future getMusicPlayMenuService() async {
  try {
    Response response = await dio.get(servicePath['getMusicPlayMenu']);
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取我关注的歌手
/// @date: 2023-07-09 11:29
Future getMySingerService(int pageNum,int pageSize) async {
  try {
    Response response = await dio.get("${servicePath['getMySinger']}?pageNum=${pageNum}&pageSize=${pageSize}");
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取我关注的歌手
/// @date: 2023-07-09 11:29
Future getMusicRecordService(int pageNum,int pageSize) async {
  try {
    Response response = await dio.get("${servicePath['getMusicRecord']}?pageNum=${pageNum}&pageSize=${pageSize}");
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取我关注的歌手
/// @date: 2023-11-20 22:15
Future insertMusicRecordService(MusicModel musicModel) async {
  try {
    Response response = await dio.post(servicePath['insertMusicRecord'],data:MusicModel.toMap(musicModel));
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}