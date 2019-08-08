import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meimei/ycolors.dart';

import 'home_root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      //anroid状态栏颜色统一
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    return MaterialApp(
      title: '悦阅',
      theme: ThemeData(
        primaryColor: AppColors.PRIMARY_TLZ_COLOR,
      ),
      home: HomeRootPage(),
      //去掉debug logo
      debugShowCheckedModeBanner: false,
    );
  }
}
