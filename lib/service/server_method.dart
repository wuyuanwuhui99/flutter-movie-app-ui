import 'dart:async';
import '../config/service_url.dart';
import '../utils/LocalStroageUtils.dart';
import 'package:dio/dio.dart';
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
    Response response;
    response = await dio.get(servicePath['getCategoryList'],
        queryParameters: {"category": category, "classify": classify});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future getKeyWordService(String classify) async {
  try {
    Response response;
    response = await dio.get(servicePath['getKeyWord'],
        queryParameters: {"classify": classify});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryByClassifyService(String classify) async {
  try {
    Response response;
    response = await dio.get(servicePath['getAllCategoryByClassify'],
        queryParameters: {"classify": classify});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryListByPageNameService(String pageName) async {
  try {
    Response response;
    response = await dio.get(servicePath['getAllCategoryListByPageName'],
        queryParameters: {"pageName": pageName});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getUserMsgService() async {
  try {
    Response response;
    response = await dio.get(servicePath['getUserMsg']);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getSearchResultService(String keyword,
    {int pageSize = 20, int pageNum = 1}) async {
  try {
    Response response;
    response = await dio.get(servicePath['getSearchResult'], queryParameters: {
      "keyword": keyword,
      "pageSize": pageSize,
      "pageNum": pageNum
    });
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//登录
Future loginService(String userId, String password) async {
  try {
    Response response;

    var map = {};
    map['userId'] = userId;
    map['password'] = password;

    response = await dio.post(servicePath['login'], data: map);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//获取演员列表
Future getStarService(String movieId) async {
  try {
    Response response;
    response = await dio.get(servicePath['getStar'], queryParameters: {
      "movieId": movieId,
    });
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getMovieUrlService(String movieId) async {
  try {
    Response response;
    response = await dio.get(servicePath['getMovieUrl'], queryParameters: {
      "movieId": "11389" //movieId,
    });
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 保存浏览记录
 * @date: 2021-03-04 23:08
 */
Future saveViewRecordService(MovieDetailModel movieEntity) async {
  try {
    Response response;
    response = await dio.post(servicePath['saveViewRecord'], data: movieEntity);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 获取浏览记录
 * @date: 2021-03-04 23:08
 */
Future getViewRecordService() async {
  try {
    Response response;
    response = await dio.get(servicePath['getViewRecord']);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 播放记录
 *  @date: 2021-03-04 23:08
 */
Future savePlayRecordService(MovieDetailModel movieEntity) async {
  try {
    Response response;
    response = await dio.post(servicePath['savePlayRecord'], data: movieEntity);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 获取播放记录
 *  @date: 2021-03-04 23:08
 */
Future getPlayRecordService() async {
  try {
    Response response;
    response = await dio.get(servicePath['getPlayRecord']);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 添加收藏
 *  @date: 2021-03-04 23:08
 */
Future saveFavoriteService(MovieDetailModel movieEntity) async {
  try {
    Response response;
    response = await dio.post(servicePath['saveFavorite'], data: movieEntity);
    print(response);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 获取收藏
 *  @date: 2021-03-04 23:08
 */
Future getFavoriteService() async {
  try {
    Response response;
    response = await dio.get(servicePath['getFavorite']);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 删除收藏
 *  @date: 2021-03-04 23:08
 */
Future deleteFavoriteService(String movieId) async {
  try {
    Response response;
    response = await dio.delete(servicePath['deleteFavorite'],
        queryParameters: {"movieId": movieId});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 获取推荐影片
 *  @date: 2021-03-04 23:08
 */
Future isFavoriteService(String movieId) async {
  try {
    Response response;
    response = await dio.get(servicePath['isFavorite'],
        queryParameters: {"movieId": movieId.toString()});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 获取猜你想看
 *  @date: 2021-03-04 23:08
 */
Future getYourLikesService(String labels) async {
  try {
    Response response;
    response = await dio
        .get(servicePath['getYourLikes'], queryParameters: {"labels": labels});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

/**
 * @author: wuwenqiang
 * @description: 获取推荐影片
 *  @date: 2021-03-04 23:08
 */
Future getRecommendSerivce(String classify) async {
  try {
    Response response;
    response = await dio.get(servicePath['getRecommend'],
        queryParameters: {"classify": classify});
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}


/**
 * @author: wuwenqiang
 * @description: 更新用户信息
 *  @date: 2021-04-20 23:57
 */
Future updateUserData(Map map) async {
  try {
    Response response;
    response = await dio.put(servicePath['updateUser'],data: map);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}


/**
 * @author: wuwenqiang
 * @description: 更新密码
 *  @date: 2021-04-20 23:57
 */
Future updatePassword(Map map) async {
  try {
    Response response;
    response = await dio.put(servicePath['updatePassword'],data: map);
    if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}