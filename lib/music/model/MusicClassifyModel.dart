class MusicClassifyModel {
  int id;// 分类id
  String classifyName; // 分类时间
  int permission;// 权限
  int classifyRank; // 分类排名
  String cover;// 分类图标
  int disabled;// 是否禁用
  String createTime;// 创建时间
  String updateTime;// 更新时间

  MusicClassifyModel({
    this.id,
    this.classifyName,
    this.permission,
    this.classifyRank,
    this.cover,
    this.disabled,
    this.createTime,
    this.updateTime
  });

  //工厂模式-用这种模式可以省略New关键字
  factory MusicClassifyModel.fromJson(dynamic json) {
    return MusicClassifyModel(
        id: json["id"],
        classifyName: json["classifyName"],
        permission: json["permission"],
        classifyRank: json["classifyRank"],
        disabled: json["disabled"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "classifyName": classifyName,
      "permission": permission,
      "classifyRank": classifyRank,
      "disabled": disabled,
      "createTime": createTime,
      "updateTime": updateTime
    };
  }
}
