import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class YWebView extends StatelessWidget {
  final String url;
  final String title;

  YWebView(this.url, {this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebviewScaffold(
          url: url,
          withJavascript: true,
          headers: {'Content-Security-Policy': 'upgrade-insecure-requests'},
          withLocalStorage: true,
          scrollBar: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )),
    );
  }
}
