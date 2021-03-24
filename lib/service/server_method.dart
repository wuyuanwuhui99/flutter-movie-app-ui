import 'dart:async';
import 'package:movie/config/Global.dart';

import '../config/service_url.dart';
import '../utils/LocalStroageUtils.dart';
import 'package:dio/dio.dart';

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
Future getUserData() async {
  try {
    Response response;
    String token = await LocalStroageUtils.getToken(); //从缓存中获取
    options.headers["Authorization"] = token;
    response = await dio.get(servicePath["getUserData"]);
    if (response.statusCode == 200) {
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

Future getCategoryList(String category, String classify) async {
  try {
    Response response;
    response = await dio.get(servicePath['getCategoryList'],
        queryParameters: {"category": category, "classify": classify});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future getKeyWord(String classify) async {
  try {
    Response response;
    response = await dio.get(servicePath['getKeyWord'],
        queryParameters: {"classify": classify});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryByClassify(String classify) async {
  try {
    Response response;
    response = await dio.get(servicePath['getAllCategoryByClassify'],
        queryParameters: {"classify": classify});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getAllCategoryListByPageName(String pageName) async {
  try {
    Response response;
    response = await dio.get(servicePath['getAllCategoryListByPageName'],
        queryParameters: {"pageName": pageName});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getUserMsg(String userId) async {
  try {
    Response response;
    response = await dio
        .get(servicePath['getUserMsg'], queryParameters: {"userId": userId});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getHistory(String userId) async {
  try {
    Response response;
    response = await dio
        .get(servicePath['getHistory'], queryParameters: {"userId": userId});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getSearchResult(String keyword,
    {int pageSize = 20, int pageNum = 1}) async {
  try {
    Response response;
    response = await dio.get(servicePath['getSearchResult'], queryParameters: {
      "keyword": keyword,
      "pageSize": pageSize,
      "pageNum": pageNum
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future login(String userId, String password) async {
  try {
    Response response;

    var map = {};
    map['userId'] = userId;
    map['password'] = password;

    response = await dio.post(servicePath['login'], data: map);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//获取演员列表
Future getStar(String movieId) async {
  try {
    Response response;
    response = await dio.get(servicePath['getStar'], queryParameters: {
      "movieId": movieId,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//按classify大类查询所有catory小类
Future getMovieUrl(String id) async {
  try {
    Response response;
    response = await dio.get(servicePath['getMovieUrl'], queryParameters: {
      "id": id,
    });
    if (response.statusCode == 200) {
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
Future saveViewRecord(Map movieEntity) async {
  try {
    Response response;
    response = await dio.post(servicePath['saveViewRecord'],data:movieEntity);
    if (response.statusCode == 200) {
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
Future getViewRecord(Map movieEntity) async {
  try {
    Response response;
    response = await dio.get(servicePath['getViewRecord']);
    if (response.statusCode == 200) {
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
Future savePlayRecord(Map movieEntity) async {
  try {
    Response response;
    response = await dio.post(servicePath['savePlayRecord'],data:movieEntity);
    if (response.statusCode == 200) {
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
Future getPlayRecord() async {
  try {
    Response response;
    response = await dio.get(servicePath['getPlayRecord']);
    if (response.statusCode == 200) {
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
Future saveFavorite(Map movieEntity) async {
  try {
    Response response;
    response = await dio.post(servicePath['saveFavorite'],data:movieEntity);
    if (response.statusCode == 200) {
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
Future getFavorite() async {
  try {
    Response response;
    response = await dio.get(servicePath['getFavorite']);
    if (response.statusCode == 200) {
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
Future deleteFavorite(String movieId) async {
  try {
    Response response;
    response = await dio.delete(servicePath['getFavorite'],queryParameters:{movieId:movieId});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}
