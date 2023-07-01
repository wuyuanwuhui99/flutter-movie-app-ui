import 'dart:async';
import 'package:dio/dio.dart';
import '../config/serviceUrl.dart';
import '../utils/LocalStroageUtils.dart';
import '../config/common.dart';
import '../model/MovieDetailModel.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 1000 * 10,
  receiveTimeout: 1000 * 20,
  //Http请求头.
  headers: {
    //可统一配置传参
    //do something
    "version": "1.0.0"
  },
  //请求的Content-Type，默认值是"application/json; charset=utf-8". 也可以用"application/x-www-form-urlencoded"
  // contentType: "application/json; charset=utf-8",
  //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
  responseType: ResponseType.json,
);
Dio dio = Dio(options);

dynamic getResponseData(Response response){
  if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
    return response.data;
  } else {
    throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
  }
}

//获取用户数据
Future getUserDataService() async {
  try {
    Response response;
    String token = await LocalStroageUtils.getToken(); //从缓存中获取
    options.headers["Authorization"] = token;
    response = await dio.get(servicePath["getUserData"]);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      options.headers["Authorization"] = response.data["token"];
      dio = Dio(options);
      return response.data;
    } else {
      return {};
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future getCategoryListService(String category, String classify) async {
  try {
    Response response = await dio.get(servicePath['getCategoryList'],
        queryParameters: {"category": category, "classify": classify});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future getKeyWordService(String classify) async {
  try {
    Response response = await dio.get(servicePath['getKeyWord'],
        queryParameters: {"classify": classify});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryByClassifyService(String classify) async {
  try {
    Response response = await dio.get(servicePath['getAllCategoryByClassify'],
        queryParameters: {"classify": classify});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryListByPageNameService(String pageName) async {
  try {
    Response response = await dio.get(servicePath['getAllCategoryListByPageName'],
        queryParameters: {"pageName": pageName});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getUserMsgService() async {
  try {
    Response response = await dio.get(servicePath['getUserMsg']);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getSearchResultService(String keyword,
    {int pageSize = 20, int pageNum = 1}) async {
  try {
    Response response = await dio.get(servicePath['getSearchResult'], queryParameters: {
      "keyword": keyword,
      "pageSize": pageSize,
      "pageNum": pageNum
    });
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//登录
Future loginService(String userId, String password) async {
  try {
    var map = {};
    map['userId'] = userId;
    map['password'] = password;
    Response response = await dio.post(servicePath['login'], data: map);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//获取演员列表
Future getStarService(int movieId) async {
  try {
    Response response = await dio.get(servicePath['getStar']+movieId.toString());
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getMovieUrlService(int movieId) async {
  try {
    Response response = await dio.get(servicePath['getMovieUrl'], queryParameters: {
      "movieId": movieId.toString(),
    });
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 播放记录
/// @date: 2021-03-04 23:08
Future savePlayRecordService(MovieDetailModel movieEntity) async {
  try {
    Response response = await dio.post(servicePath['savePlayRecord'], data: movieEntity.toMap());
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取播放记录
/// @date: 2021-03-04 23:08
Future getPlayRecordService() async {
  try {
    Response response = await dio.get(servicePath['getPlayRecord']);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 添加收藏
/// @date: 2021-03-04 23:08
Future saveFavoriteService(MovieDetailModel movieEntity) async {
  try {
    Response response = await dio.post(servicePath['saveFavorite'], data: movieEntity);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取收藏
/// @date: 2021-03-04 23:08
Future getFavoriteService() async {
  try {
    Response response = await dio.get(servicePath['getFavorite']);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 删除收藏
/// @date: 2021-03-04 23:08
Future deleteFavoriteService(int movieId) async {
  try {
    Response response = await dio.delete(servicePath['deleteFavorite'],
        queryParameters: {"movieId": movieId});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取推荐影片
/// @date: 2021-03-04 23:08
Future isFavoriteService(int movieId) async {
  try {
    Response response = await dio.get(servicePath['isFavorite'],
        queryParameters: {"movieId": movieId.toString()});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取猜你想看
/// @date: 2021-03-04 23:08
Future getYourLikesService(String labels) async {
  try {
    Response response = await dio.get(servicePath['getYourLikes'], queryParameters: {"labels": labels});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取推荐影片
/// @date: 2021-03-04 23:08
Future getRecommendSerivce(String classify) async {
  try {
    Response response = await dio.get(servicePath['getRecommend'],
        queryParameters: {"classify": classify});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}


///@author: wuwenqiang
///@description: 更新用户信息
/// @date: 2021-04-20 23:57
Future updateUserData(Map map) async {
  try {
    Response response = await dio.put(servicePath['updateUser'],data: map);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}


///@author: wuwenqiang
///@description: 更新密码
/// @date: 2021-04-20 23:57
Future updatePasswordService(Map map) async {
  try {
    Response response = await dio.put(servicePath['updatePassword'],data: map);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取评论总数
/// @date: 2021-10-26 23:05
Future getCommentCountService(int relationId,String type) async {
  try {
    Response response = await dio.get(servicePath['getCommentCount'],queryParameters: {"relationId": relationId,"type":type});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取一级评论
/// @date: 2021-10-28 22:01
Future getTopCommentListService(int relationId,String type,int pageSize,int pageNum) async {
  try {
    Response response = await dio.get(servicePath['getTopCommentList'],queryParameters: {"relationId": relationId,"type":type,"pageSize":pageSize,"pageNum":pageNum});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}


///@author: wuwenqiang
///@description: 获取回复数量
/// @date: 2021-10-29 22:54
Future getReplyCommentListService(int topId,int pageSize,int pageNum) async {
  try {
    Response response = await dio.get(servicePath['getReplyCommentList'],queryParameters: {"topId": topId,"pageSize":pageSize,"pageNum":pageNum});
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 新增评论
/// @date: 2021-10-31 10:31
Future insertCommentService(Map commentMap) async {
  try {
    Response response = await dio.post(servicePath['insertCommentService'],data:commentMap);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 头像上传
/// @date: 2022-12-17 22:44
Future updateAvaterService(Map avaterMap) async {
  try {
    Response response = await dio.put(servicePath['updateAvaterService'],data:avaterMap);
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取音乐搜索框关键词
/// @date: 2023-05-18 23:32
Future getKeyWordMusicService() async {
  try {
    Response response = await dio.get(servicePath['getKeywordMusic']);
    return getResponseData(response);
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
    return getResponseData(response);
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
    return getResponseData(response);
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
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取分类音乐列表
/// @date: 2023-05-25 22:45
Future getCircleListByType(String type,int pageNum,int pageSize) async {
  try {
    Response response = await dio.get("${servicePath['getCircleListByType']}?type=${type}&pageNum=${pageNum}&pageSize=${pageSize}");
    return getResponseData(response);
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}