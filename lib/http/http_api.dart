import 'package:flustars/flustars.dart';
import 'package:meimei/constant/constant.dart';

import 'http_response.dart';
import 'httputil.dart';

class HttpApi {
  ///获取图片
  static getMeiTuData(page, {count: 20}) async {
    String url = 'http://gank.io/api/data/福利/$count/$page';
    print('美图请求链接 $url');
    HttpResponse httpResponse = await HttpUtil.instance.request(url);
    return httpResponse.data;
  }

  ///获取知乎banner列表
  static getZhiHuBanner() async {
    String url = 'https://news-at.zhihu.com/api/4/news/latest';
    HttpResponse httpResponse = await HttpUtil.instance.request(url);
    return httpResponse.data;
  }

  ///获取知乎item列表
  static getZhiHuItem({String date}) async {
    print('最终日期: $date');
    if (date.isEmpty) {
      date = DateUtil.formatDate(DateTime.now(), format: 'yyyyMMdd');
    }
    String url = Constant.ZhiHu_Item_Url + date;
    print('请求链接: $url');
    HttpResponse httpResponse = await HttpUtil.instance.request(url);
    return httpResponse.data;
  }
}
