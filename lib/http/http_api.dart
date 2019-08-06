import 'http_response.dart';
import 'httputil.dart';

class HttpApi {
  //获取图片
  static getMeiTuData(page, {count: 20}) async {
    String url = 'http://gank.io/api/data/福利/$count/$page';
    print('美图请求链接 $url');
    HttpResponse httpResponse = await HttpUtil.instance.request(url);
    return httpResponse.data;
  }
}
