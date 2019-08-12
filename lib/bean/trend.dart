///动态
class TrendBean {
  final String url; //网页介绍地址
  final String dateS; //时间
  final String title; //标题
  final String author; //作者

  TrendBean(this.url, this.dateS, this.title, this.author);

  TrendBean.fromJson(Map<String, dynamic> json)
      : url = json['originalUrl'],
        dateS = json['updatedAt'],
        author = json['user']['username'],
        title = json['title'];

//  Map<String, dynamic> toJson() => {
//        'desc': desc,
//        'url': url,
//      };
}
