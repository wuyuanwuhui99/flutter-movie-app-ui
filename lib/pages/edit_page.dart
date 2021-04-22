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

  void initState() {
    myController.text = widget.value;
    myController.addListener(() {
      setState(() {
        hasChange = myController.text != widget.value ? true : false;
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
          Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 20),child: Column(
            children: <Widget>[
              Container(
                height: 40,
                child:
                Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
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
                                myUserInfo[widget.field] = myController.text;
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
              ),
              TextField(
                controller: myController,
                onChanged: (value){
                  setState(() {
                    hasChange = true;
                  });
                },)
            ],
          ),)
      ),);
  }
}