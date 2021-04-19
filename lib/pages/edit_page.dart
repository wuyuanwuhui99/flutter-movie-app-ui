import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  final String title;
  EditPage({this.title});

  @override
  Widget build(BuildContext context) {
    var myController = new TextEditingController();
    myController.text = "111";

    return Scaffold(
        body:
        Padding(padding: EdgeInsets.all(20),child: Column(
          children: <Widget>[
            Column(
                children: <Widget>[
                  Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Center(child: Text(title)),
                        Positioned(
                            top: 0,
                            right: 0,child:RaisedButton(
                        child: Text('保存'),
                        onPressed: (){},
                      ) )]),
                ]),
            TextField(
              controller: myController,
              onChanged: (value){

              },)
          ],
        ),)
    );
  }
}
