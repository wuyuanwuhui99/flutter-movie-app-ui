
import '../config/common.dart';
import 'package:dio/dio.dart';

// 网络请求工具类
class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;
  String token;

  void setToken(String mToken){
    token = mToken;
  }

  static HttpUtil getInstance(){
    if (null == instance) instance = new HttpUtil();
    return instance;
  }

  HttpUtil(){
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: HOST,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0",
        'Content-Type':'application/json '
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: Headers.jsonContentType,
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    dio = new Dio(options);
    // 添加请求后拦截器
    dio.interceptors.add(InterceptorsWrapper(
        onResponse: (Response response){
          if (response.statusCode == 200 && response.data["status"] == SUCCESS) {
            return response;
          } else {
            throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
          }
        },
        onRequest: (RequestOptions options){
          options.headers['Authorization'] = token;
          return options;
        },
        onError: (DioError dioError){
          print(dioError.request);
          return dioError;
        }
    ));
  }
}

Dio dio = HttpUtil.getInstance().dio;