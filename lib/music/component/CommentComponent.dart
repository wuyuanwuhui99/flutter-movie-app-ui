import 'package:flutter/material.dart';
import 'package:movie/movie/model/CommentModel.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../../config/common.dart';
import '../../utils/common.dart';
import '../service/serverMethod.dart';

class CommentComponent extends StatefulWidget {
  final List<CommentModel> commentList;
  final int relationId;
  final CommentEnum type;
  CommentComponent({Key key, this.commentList,this.relationId,this.type}) : super(key: key);

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent>{
  List<CommentModel>commentList = [];
  @override
  void initState() {
    super.initState();
    commentList.addAll(widget.commentList);
  }

  CommentModel replyCommentModel;
  CommentModel firstCommentModel;
  bool disabledSend = false;
  bool loading = false;
  TextEditingController inputController = new TextEditingController(); // 评论框的控制条

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(flex: 1,child: SingleChildScrollView(child:Padding(padding: ThemeStyle.padding,child: buildCommentList(commentList),))),
      buildSendWidget()
    ],);
    return buildCommentList(commentList);
  }

  Widget buildCommentList(List<CommentModel>commentList){
    return Column(children:commentList.map((CommentModel commentModel){
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipOval(
            child: Image.network(
              //从全局的provider中获取用户信息
              HOST + commentModel.avater,
              height: commentModel.topId != null ? ThemeSize.smallAvater : ThemeSize.middleAvater,
              width: commentModel.topId != null ? ThemeSize.smallAvater : ThemeSize.middleAvater,
              fit: BoxFit.cover,
            )),
        SizedBox(width: ThemeSize.smallMargin),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  commentModel.replyUserName != null ? '${commentModel.username}▶${commentModel.replyUserName}'
                      : commentModel.username,
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
                      firstCommentModel = commentList.firstWhere((element) => element.id == replyCommentModel.topId);
                    }
                  });
                },
              ),
              SizedBox(height: ThemeSize.smallMargin),
              Text(formatTime(commentModel.createTime),
                  style: TextStyle(color: ThemeColors.subTitle)),
              SizedBox(height: ThemeSize.smallMargin),
              buildCommentList(commentModel.replyList)
            ])
      ]);
    }).toList());
  }

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
                            hintText: replyCommentModel != null ? "回复${replyCommentModel.username}"
                                : (firstCommentModel != null ? "回复${firstCommentModel.username}" : "评论"),
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
          Container(
            height: ThemeSize.middleAvater,
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                if(loading)return;
                loading = true;
                CommentModel mCommentModel = CommentModel(
                    type:widget.type.toString().split('.').last,
                    relationId:widget.relationId,
                    content: inputController.text,
                    topId:firstCommentModel != null ? firstCommentModel.id : null,
                    parentId:replyCommentModel != null ? replyCommentModel.id : null
                );
                insertCommentService(mCommentModel).then((value){
                  loading = false;
                  inputController.text = "";
                  setState(() {
                    if(firstCommentModel != null){
                      firstCommentModel.replyList.add(CommentModel.fromJson(value.data));
                      ;                        }else{
                      commentList.add(CommentModel.fromJson(value.data));
                    }
                  });
                  firstCommentModel = replyCommentModel = null;
                  inputController.text = "";
                });
              },
              child: Text(
                '发送',
                style: TextStyle(
                    fontSize: ThemeSize.middleFontSize,
                    color: Colors.white),
              ),

              ///圆角
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ThemeSize.bigRadius))),
            ),
          )
        ]));
  }
}