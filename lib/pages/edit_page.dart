import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String title;
  final String type;
  final String value;
  EditPage({Key key, this.type,this.title,this.value}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    var myController = new TextEditingController();
    myController.text = widget.value;

    return Scaffold(
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
                        child:RaisedButton(
                          child: Text('保存'),
                          onPressed: (){},
                        ) )]),
            ),
            TextField(
              controller: myController,
              onChanged: (value){

              },)
          ],
        ),)
    );
  }
}