import 'package:flutter/material.dart';
import '../service/server_method.dart';
import 'package:provider/provider.dart';
import '../provider/UserInfoProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditPage extends StatefulWidget {
  final String title;//编辑的标题
  final String type;//编辑框的类型
  final String value;//输入框的值
  final String field;//对应的userInfo字段
  final bool isAllowEmpty;//是否允许为空

  EditPage({Key key, this.type,this.title,this.value,this.field,this.isAllowEmpty}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  TextEditingController myController = new TextEditingController();
  bool hasChange = false;
  int tabIndex = 0;
  String checkValue = "";

  void initState() {
    checkValue = myController.text = widget.value;
    myController.addListener(() {
      setState(() {
        hasChange = myController.text != widget.value ? true : false;
        checkValue = myController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    return
      FlutterEasyLoading(
        child: Scaffold(
          body:
         Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(20),child: Container(
                height: 40,
                child:
                Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Image.asset("lib/assets/images/icon-back.png",
                    width: 20, height: 20),),
                      Center(child: Text(widget.title)),
                      Positioned(
                          top: 0,
                          right: 0,
                          child:
                          InkWell(
                              onTap: ()async{
                                if(!hasChange)return;
                                if(!widget.isAllowEmpty && myController.text == ""){
                                  Fluttertoast.showToast(
                                      msg: "${widget.title}不能为空",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      fontSize: 16.0
                                  );
                                  return;
                                }
                                await EasyLoading.show();
                                Map myUserInfo = Map.from(userInfo);
                                myUserInfo[widget.field] = checkValue;
                                updateUserData(myUserInfo).then((value)async{
                                  setState(() {
                                    hasChange = false;
                                  });
                                  Provider.of<UserInfoProvider>(context).setUserInfo(myUserInfo);
                                  await EasyLoading.dismiss(animation: true);
                                  Navigator.pop(context);
                                }).catchError((){

                                });
                              },
                              child: Container(
                                  width: 70,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    color: hasChange ? Color.fromRGBO(24, 144, 255,1) : Color.fromRGBO(221, 221, 221,1),
                                  ),
                                  child: Center(child: Text('保存',style: TextStyle(color: hasChange ? Colors.white : Color.fromRGBO(204, 204, 204,1)),))
                              )
                          )
                      )]),
              ),),
              
              Options()
            ],
          ),)
      );
  }

  Widget Options(){
    if(widget.field == "sex"){//性别判断
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child:
          Column(
              children: <Widget>[
                InkWell(
                    onTap: (){
                      setState(() {
                        hasChange = true;
                        checkValue = "男";
                      });
                    },
                    child:
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child:Row(
                                children: <Widget>[
                                  Expanded(flex: 1,child: Text("男")),
                                  checkValue == "男" ? Icon(
                                    Icons.check,
                                    color: Color.fromRGBO(24, 144, 255, 1),
                                  ):SizedBox(),
                                ])),)
                        ,
                    ),
                Container(height: 1,decoration: BoxDecoration(color: Color.fromRGBO(204, 204, 204, 1)),),
                InkWell(
                    onTap: (){
                      setState(() {
                        hasChange = true;
                        checkValue = "女";
                      });
                    },
                    child:
                        Padding(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child:Container(
                          alignment: Alignment.center,
                          height: 60,
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(flex: 1,child: Text("女")),
                              checkValue == "女" ? Icon(
                                Icons.check,
                                color: Color.fromRGBO(24, 144, 255, 1),
                              ):SizedBox(),
                            ],)) ,)
                      ,
                   )
              ]),);
    }else if(widget.field == "birthday"){
      int year = 0,month = 0,day = 0;
      List patter = widget.value != null && widget.value != "" ? widget.value.split("-"):[];
      if(patter.length > 0){
        year = int.parse(patter[0]);
        month = int.parse(patter[1]);
        day = int.parse(patter[2]);
      }else{
        DateTime dateTime = DateTime.now();
        year = dateTime.year - 20;
        month = dateTime.month;
        day = dateTime.day;
      }
      return
        InkWell(
          onTap: (){
            showDatePicker(
                context: context,
                initialDate: DateTime(year,month,day), // 初始化选中日期
                firstDate: DateTime(1900, 6),  // 开始日期
                lastDate:  DateTime.now(),  // 结束日期
                textDirection: TextDirection.ltr,  // 文字方向
                helpText: "helpText", // 左上方提示
                cancelText: "cancelText",  // 取消按钮文案
                confirmText: "confirmText",  // 确认按钮文案

                errorFormatText: "errorFormatText",  // 格式错误提示
                errorInvalidText: "errorInvalidText",  // 输入不在 first 与 last 之间日期提示

                fieldLabelText: "fieldLabelText",  // 输入框上方提示
                fieldHintText: "fieldHintText",  // 输入框为空时内部提示

                initialDatePickerMode: DatePickerMode.day, // 日期选择模式，默认为天数选择
                useRootNavigator: true, // 是否为根导航器
            ).then((DateTime date) {
              if(date == null)return;
              setState(() {
                hasChange = true;
                myController.text = checkValue = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
              });
            });
          },
          child: Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            enabled: false,
            controller: myController,
            ),),);
    }else{
      return 
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
          controller: myController,
          onChanged: (value){
            setState(() {
              hasChange = true;
            });
          },),);
    }
  }
}