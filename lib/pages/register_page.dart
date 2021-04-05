import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int groupValue = 0;

  void _handleRadioValueChanged(int value) {
    setState(() {
      groupValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            child: Padding(
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text("用户名"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入用户名",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("密码"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入密码",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("确认密码"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "确认密码",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("昵称"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入昵称",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("电话"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入电话号码",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("邮箱"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入邮箱地址",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("出生年月日"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入邮箱地址",
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                child: Text("性别"),
                width: 80,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Text("男"),
                    Radio(
                        value: 0,
                        groupValue: groupValue,
                        // title: Text("男"),
                        onChanged: _handleRadioValueChanged),
                    SizedBox(width: 20),
                    Text("女"),
                    Radio(
                        value: 1,
                        groupValue: groupValue,
                        onChanged: _handleRadioValueChanged),
                  ],
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text("注册",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: Color.fromRGBO(237, 237, 237, 1))),
          )
        ],
      ),
    )));
    ;
  }
}
