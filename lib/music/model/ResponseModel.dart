class ResponseModel<T> {
  final String status;
  final String msg;
  final int total;
  final String token;
  final T data;
  ResponseModel({
    this.status,
    this.msg,
    this.total,
    this.token,
    this.data
  });

  //工厂模式-用这种模式可以省略New关键字
  factory ResponseModel.fromJson(dynamic json) {
    return ResponseModel(
        status:json["status"],
        msg:json["msg"],
        total:json["total"],
        token:json["token"],
        data:json["data"] as T);
  }
}

