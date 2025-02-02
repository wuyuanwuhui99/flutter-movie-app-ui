import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../provider/UserInfoProvider.dart';
import '../provider/TokenProvider.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({super.key,required this.url,required this.title});

  @override
  createState() => _WebViewPageState(this.url, this.title);
}

class _WebViewPageState extends State<WebViewPage> {
  final String _url;
  final String _title;
  late WebViewController controller;
  _WebViewPageState(this._url, this._title);

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            //页面加载完成后才能执行js
            // _handleBackForbid();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebViewWidget(
              controller: controller,
            )));
  }
}
