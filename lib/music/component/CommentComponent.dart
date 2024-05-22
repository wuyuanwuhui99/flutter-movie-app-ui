import 'package:flutter/material.dart';
import 'package:movie/movie/model/CommentModel.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../../config/common.dart';
import '../../utils/common.dart';

class CommentComponent extends StatefulWidget {
  final List<CommentModel> commentList;
  final int relationId;
  CommentComponent({Key key, this.commentList,this.relationId}) : super(key: key);

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent>{
  CommentModel replyCommentModel;
  CommentModel firstCommentModel;

  @override
  Widget build(BuildContext context) {
    return Column(children:widget.commentList.map((CommentModel commentModel){
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipOval(
            child: Image.network(
              //从全局的provider中获取用户信息
              HOST + commentModel.avater,
              height: replyCommentModel == null
                  ? ThemeSize.middleAvater
                  : ThemeSize.middleAvater / 2,
              width: replyCommentModel == null
                  ? ThemeSize.middleAvater
                  : ThemeSize.middleAvater / 2,
              fit: BoxFit.cover,
            )),
        SizedBox(width: ThemeSize.smallMargin),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  commentModel.replyUserName != null
                      ? '${commentModel.username}▶${commentModel.replyUserName}'
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
                      firstCommentModel = widget.commentList.firstWhere((element) => element.id == replyCommentModel.topId);
                    }
                    // buildCommentInputDailog();
                  });
                },
              ),
              SizedBox(height: ThemeSize.smallMargin),
              Text(formatTime(commentModel.createTime),
                  style: TextStyle(color: ThemeColors.subTitle)),
              SizedBox(height: ThemeSize.smallMargin),
            ])
      ]);
    }).toList());
  }
}