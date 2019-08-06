class MeiTuBean {
  final String desc;
  final String url;

  MeiTuBean(this.desc, this.url);

  MeiTuBean.fromJson(Map<String, dynamic> json)
      :desc=json['desc'],
        url=json['url'];

  Map<String, dynamic> toJson() => {
  'desc':desc,
  'url':url,
};}