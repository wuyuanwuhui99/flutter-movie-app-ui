import 'package:flutter/material.dart';
import '../model/CommentModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../common/constant.dart';
import '../common/config.dart';
import '../utils/common.dart';
import '../service/serverMethod.dart';

class CommentComponent extends StatefulWidget {
  final int relationId;
  final CommentEnum type;
  const CommentComponent({super.key,required this.relationId,required this.type});

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent>{
  List<CommentModel>commentList = [];
  CommentModel? replyCommentModel;
  CommentModel? firstCommentModel;
  bool disabledSend = false;
  bool loading = false;
  int commentTotal = 0;
  TextEditingController inputController = new TextEditingController(); // 评论框的控制条

  @override
  void initState() {
    super.initState();
    getTopCommentListService(widget.relationId, CommentEnum.MOVIE, 1,20).then((res) {
      setState(() {
        for (var element in res.data) {
          commentList.add(CommentModel.fromJson(element));
        }
        commentTotal = res.total!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: ThemeStyle.padding,child: Text('${commentTotal.toString()}条评论',textAlign: TextAlign.center)),
      Divider(height: 1,color:ThemeColors.borderColor),
      Expanded(flex: 1,child: commentList.isNotEmpty ? SingleChildScrollView(child:Padding(padding: ThemeStyle.padding,child: buildCommentList(commentList),)):const Center(child: Text("暂无评论"))),
      Divider(height: 1,color:ThemeColors.borderColor),
      buildSendWidget()
    ]);
  }

  ///@author: wuwenqiang
  ///@description: 创建评论和回复列表
  /// @date: 2024-05-25 14:28
  Widget buildCommentList(List<CommentModel>commentList){
    return Column(children:commentList.map((CommentModel commentModel){
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipOval(
            child: commentModel.avater == null ? Image.network(
              //从全局的provider中获取用户信息
              "$HOST${commentModel.avater}",
              height: commentModel.topId != null ? ThemeSize.smallAvater : ThemeSize.middleAvater,
              width: commentModel.topId != null ? ThemeSize.smallAvater : ThemeSize.middleAvater,
              fit: BoxFit.cover,
            ) : Image.asset(
      "lib/assets/images/default_avater.png",
      width: ThemeSize.middleIcon,
      height: ThemeSize.middleIcon,
      )),
        SizedBox(width: ThemeSize.smallMargin),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  commentModel.replyUserName != null ? '${commentModel.username}▶${commentModel.replyUserName}'
                      : commentModel.username!,
                  style: TextStyle(color: ThemeColors.subTitle)),
              SizedBox(height: ThemeSize.smallMargin),
              GestureDetector(
                child: Text(commentModel.content),
                onTap: () {
                  setState(() {
                    if(commentModel.topId == null){// 如果不是二级评论
                      replyCommentModel = firstCommentModel = commentModel;
                    }else{// 如果是二级评论
                      replyCommentModel = commentModel;
                      firstCommentModel = commentList.firstWhere((element) => element.id == replyCommentModel?.topId);
                    }
                  });
                },
              ),
              SizedBox(height: ThemeSize.smallMargin),
              Text(formatTime(commentModel.createTime!),
                  style: TextStyle(color: ThemeColors.subTitle)),
              SizedBox(height: ThemeSize.smallMargin),
              buildCommentList(commentModel.replyList!)
            ])
      ]);
    }).toList());
  }

  ///@author: wuwenqiang
  ///@description: 创建发送按钮
  /// @date: 2024-05-25 14:28
  Widget buildSendWidget(){
    return Container(
        decoration: BoxDecoration(color: ThemeColors.colorWhite),
        padding: ThemeStyle.padding,
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Material(
                  child: Container(
                      height: ThemeSize.middleAvater,
                      child: TextField(
                          controller: inputController,
                          cursorColor: Colors.grey, //设置光标
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ThemeColors.colorBg,
                            hintText: replyCommentModel != null ? "回复${replyCommentModel?.username}"
                                : (firstCommentModel != null ? "回复${firstCommentModel?.username}" : "评论"),
                            hintStyle: TextStyle(
                                fontSize: ThemeSize.smallFontSize,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  ThemeSize.middleAvater), // 圆角的大小
                            ),
                            contentPadding: EdgeInsets.only(
                                left: ThemeSize.smallMargin),
                          ))))),
          SizedBox(width: ThemeSize.containerPadding),
          SizedBox(
            height: ThemeSize.middleAvater,
            child: ElevatedButton(
              onPressed: () {
                if(loading)return;
                loading = true;
                CommentModel mCommentModel = CommentModel(
                    type:widget.type.toString().split('.').last,
                    relationId:widget.relationId,
                    content: inputController.text,
                    topId:firstCommentModel?.id,
                    parentId:replyCommentModel?.id
                );
                insertCommentService(mCommentModel.toMap()).then((value){
                  loading = false;
                  inputController.text = "";
                  setState(() {
                    if(firstCommentModel != null){
                      firstCommentModel?.replyList?.add(CommentModel.fromJson(value.data));
                    }else{
                      commentList.add(CommentModel.fromJson(value.data));
                    }
                  });
                  firstCommentModel = replyCommentModel = null;
                  inputController.text = "";
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(ThemeColors.blueColor), // 按扭背景颜色
                foregroundColor: WidgetStateProperty.all(Colors.white), // 按钮文本颜色
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeSize.bigRadius))), // 圆角
              ),
              child: Text(
                '发送',
                style: TextStyle(
                    fontSize: ThemeSize.middleFontSize,
                    color: Colors.white),
              ),
            ),
          )
        ]));
  }
}