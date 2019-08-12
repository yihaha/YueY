///玩安卓项目列表item
class WanAndroid {
  final String desc;
  final String url; //网页介绍地址
  final String proUrl; //项目地址
  final String imgUrl; //图片地址
  final String dateS; //时间
  final String title; //标题
  final String author; //作者

  WanAndroid(this.desc, this.url, this.proUrl, this.imgUrl, this.dateS,
      this.title, this.author);

  WanAndroid.fromJson(Map<String, dynamic> json)
      : desc = json['desc'],
        url = json['link'],
        proUrl = json['projectLink'],
        imgUrl = json['envelopePic'],
        dateS = json['niceDate'],
        author = json['author'],
        title = json['title'];

//  Map<String, dynamic> toJson() => {
//        'desc': desc,
//        'url': url,
//      };
}
