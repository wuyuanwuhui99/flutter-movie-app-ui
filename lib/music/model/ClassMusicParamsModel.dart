class ClassMusicParamsModel {
  int classifyId; // 分类id
  int pageNum; // 第几页，从1开始
  int pageSize; // 每页显示条数
  int isRedis; // 是否从redis中获取

  ClassMusicParamsModel(
      {this.classifyId, this.pageNum, this.pageSize, this.isRedis});

  //工厂模式-用这种模式可以省略New关键字
  factory ClassMusicParamsModel.fromJson(dynamic json) {
    return ClassMusicParamsModel(
        classifyId: json["classifyId"],
        pageNum: json["pageNum"],
        pageSize: json["pageSize"],
        isRedis: json["isRedis"]);
  }

  //工厂模式-用这种模式可以省略New关键字
  static Map toMap(ClassMusicParamsModel classMusicParamsModel) {
    return {
      "classifyId": classMusicParamsModel.classifyId,
      "pageNum": classMusicParamsModel.pageNum,
      "pageSize": classMusicParamsModel.pageSize,
      "isRedis": classMusicParamsModel.isRedis,
    };
  }
}
