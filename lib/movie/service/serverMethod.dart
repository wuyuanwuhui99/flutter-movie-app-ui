import 'dart:async';
import 'package:dio/dio.dart';
import '../api//api.dart';
import '../../utils/LocalStroageUtils.dart';
import '../model/MovieDetailModel.dart';
import '../../utils/HttpUtil .dart';

//获取用户数据
Future getUserDataService() async {
  try {
    String token = await LocalStroageUtils.getToken(); //从缓存中获取
    HttpUtil.getInstance().setToken(token);
    print("------------------------------------");
    print(servicePath["getUserData"]);
   Response response = await dio.get(servicePath["getUserData"]);
    HttpUtil.getInstance().setToken(response.data['token']);
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future getCategoryListService(String category, String classify) async {
  try {
    Response response = await dio.get(servicePath['getCategoryList'],
        queryParameters: {"category": category, "classify": classify});
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future getKeyWordService(String classify) async {
  try {
    Response response = await dio.get(servicePath['getKeyWord'],
        queryParameters: {"classify": classify});
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryByClassifyService(String classify) async {
  try {
    Response response = await dio.get(servicePath['getAllCategoryByClassify'],
        queryParameters: {"classify": classify});
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryListByPageNameService(String pageName) async {
  try {
    Response response = await dio.get(servicePath['getAllCategoryListByPageName'],
        queryParameters: {"pageName": pageName});
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getUserMsgService() async {
  try {
    Response response = await dio.get(servicePath['getUserMsg']);
    return response.data;
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
    return response.data;
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
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//获取演员列表
Future getStarService(int id) async {
  try {
    Response response = await dio.get(servicePath['getStar']+id.toString());
    return response.data;
  } catch (e) {
    print(servicePath['getStar']);
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getMovieUrlService(int movieId) async {
  try {
    Response response = await dio.get(servicePath['getMovieUrl'], queryParameters: {
      "movieId": movieId.toString(),
    });
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 播放记录
/// @date: 2021-03-04 23:08
Future savePlayRecordService(MovieDetailModel movieEntity) async {
  try {
    Response response = await dio.post(servicePath['savePlayRecord'], queryParameters: movieEntity.toMap());
    return response.data;
  } catch (e) {
    print(servicePath['savePlayRecord']);
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取播放记录
/// @date: 2021-03-04 23:08
Future getPlayRecordService() async {
  try {
    Response response = await dio.get(servicePath['getPlayRecord']);
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
  } catch (e) {
    print(servicePath['getCommentCount']);
    return print('ERROR:======>${e}');
  }
}

///@author: wuwenqiang
///@description: 获取一级评论
/// @date: 2021-10-28 22:01
Future getTopCommentListService(int relationId,String type,int pageSize,int pageNum) async {
  try {
    Response response = await dio.get(servicePath['getTopCommentList'],queryParameters: {"relationId": relationId,"type":type,"pageSize":pageSize,"pageNum":pageNum});
    return response.data;
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
    return response.data;
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
    return response.data;
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
    return response.data;
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}