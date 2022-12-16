import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final url;
  final title;

  WebViewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  createState() => _WebViewPageState(this.url, this.title);
}

class _WebViewPageState extends State<WebViewPage> {
  var _url;
  var _title;
  final _key = UniqueKey();

  _WebViewPageState(this._url, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url,
            )));
  }
}
