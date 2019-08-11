import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YScreenUtil {
  ///获取屏幕宽 ,注意: MediaQuery.of(context).padding.top 方法在release版本可能出现白屏
  static double getWinWidth() {
    return window.physicalSize.width;

    ///或者
    /// MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    ///    return mediaQuery.size.width;
  }

  ///获取屏幕高度
  static double getWinHeight() {
    return window.physicalSize.height;

    ///或者
    /// MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    ///    return mediaQuery.size.height;
  }

  ///获取appbar的高度
  static double getBarHeight() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  ///状态栏高度
  static double getStatusHeight() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.padding.top;
  }

  ///更新状态栏样式,字体颜色改变
  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    ///不加定时可能出现整个statusbar颜色改变
    Timer(Duration(milliseconds: 678), () {
      SystemChrome.setSystemUIOverlayStyle(style);
    });
  }
}
