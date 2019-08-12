class Constant {
  ///知乎最新信息
  static const String ZhiHu_Last =
      'https://news-at.zhihu.com/api/4/news/latest';

  ///后面拼接上id,跳转到具体页面
  static const String ZhiHu_Web_Url = 'https://daily.zhihu.com/story/';

  ///后面拼接上日期(例如: 20190811),获取日期对应列表
  static const String ZhiHu_Item_Url =
      'https://news-at.zhihu.com/api/4/news/before/';

  ///玩安卓
  static const String WanA_Base = 'https://www.wanandroid.com/project/list/';

  ///加上页码和上面链接拼接
  static const String WanA_Pro = '/json?cid=294';

  ///动态列表
  static const String Trend_Url='https://timeline-merger-ms.juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438&sort=rankIndex';
}
