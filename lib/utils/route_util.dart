import 'package:flutter/cupertino.dart';
import 'package:meimei/widget/img_widget.dart';
import 'package:meimei/widget/web_page.dart';

class RouteUtil {
  ///使用ios的跳转,有右滑动返回
  static push(BuildContext context, Widget wid) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => wid));
  }

  ///跳转到图片查看页
  static routeToImg(
      BuildContext context, List<String> urls, List<String> titleList,
      {int position}) {
    push(context, ImgPage(urls, titleList, index: position));
  }

  ///跳转到web页
  static routeToWeb(BuildContext context, url, {String title}) {
    push(context, YWebView(url, title: title));
  }
}
