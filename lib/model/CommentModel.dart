class CommentModel{
  int? id;//主键
  String type;// 类型
  String content;//评论内容
  int? parentId;//父节点id
  int? topId;//顶级节点id
  int relationId;//影片id
  String? createTime;//创建时间
  String? updateTime;//更新时间
  int? replyCount;//回复数量
  String? userId;//用户id
  String? username;//用户名
  String? avater;//用户头像
  String? replyUserId;//被回复者id
  String? replyUserName;//被回复者名称
  String? showCommentCount;//显示的回复数量
  int? replyPageNum;
  List<CommentModel>?replyList;
  CommentModel({
    this.id,
    required this.type,
    required this.content,
    this.parentId,
    this.topId,
    required this.relationId,
    this.createTime,
    this.updateTime,
    this.replyCount,
    this.userId,
    this.username,
    this.avater,
    this.replyUserId,
    this.replyUserName,
    this.replyPageNum,
    this.replyList
  });
  //工厂模式-用这种模式可以省略New关键字
  factory CommentModel.fromJson(dynamic json){
    return CommentModel(
        id:json['id'],
        type:json['type'],
        content:json['content'],
        parentId:json['parentId'],
        topId:json['topId'],
        relationId:json['relationId'],
        createTime:json['createTime'],
        updateTime:json['updateTime'],
        replyCount:json['replyCount'],
        userId:json['userId'],
        username:json['username'],
        avater:json['avater'],
        replyUserId:json['replyUserId'],
        replyUserName:json['replyUserName'],
        replyPageNum:0,
        replyList: ((json['replyList'] == null ? [] : json['replyList'])as List).map((item){
          return CommentModel.fromJson(item);
        }).toList()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'type':type,
      'content':content,
      'parentId':parentId,
      'topId':topId,
      'relationId':relationId,
      'createTime':createTime,
      'updateTime':updateTime,
      'replyCount':replyCount,
      'userId':userId,
      'username':username,
      'avater':avater,
      'replyUserId':replyUserId,
      'replyUserName':replyUserName,
    };
  }
}