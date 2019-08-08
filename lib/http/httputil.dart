import 'dart:collection';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

import 'package:meimei/constant/string.dart';
import 'http_response.dart';

class HttpUtil {
  Dio mDio;

  //这里用到了单例,下面是单例模式
  static HttpUtil get instance => _getInstance();
  static HttpUtil _instance;

  //构造方法
  HttpUtil._internal() {
    if (mDio == null) {
      mDio = Dio();
    }
  }

  static HttpUtil _getInstance() {
    if (_instance == null) {
      _instance = HttpUtil._internal();
    }
    return _instance;
  }

  Future<HttpResponse> request(url, {meth: 'get', params, header}) async {
    //请求头
    Map<String, String> headerMap = HashMap();
    if (null != header) {
      headerMap.addAll(header);
    }

    Options yOptions = Options();
    yOptions.headers = headerMap;
    yOptions.method = meth;
    yOptions.connectTimeout = 5 * 60 * 1000;
    yOptions.receiveTimeout = 5 * 60 * 1000;

    //是否有网络
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //无网络
      return HttpResponse(-1, false, YString.NETWORK_NOT);
    }

    Response response;
    try {
      response = await mDio.request(url, data: params, options: yOptions);
    } catch (e) {
      return HttpResponse(-1, false, e.toString());
    }

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpResponse(1, true, response.data);
      }
    } catch (e) {
      return HttpResponse(-1, false, e.toString());
    }

    return HttpResponse(response.statusCode, true, 'Error');
  }
}
