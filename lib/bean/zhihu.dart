class ZhiHuBanner {
  final String title;
  final int id;
  final String image;

  ZhiHuBanner(this.title, this.id, this.image);

  ZhiHuBanner.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        id = json['id'];

  Map<String, dynamic> toJson() => {'title': title, 'image': image, 'id': id};
}

class ZHItemBean {
  final String title;
  final int id;
  final String image;

  ZHItemBean(this.title, this.id, this.image);

  ZHItemBean.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        id = json['id'];

  Map<String, dynamic> toJson() => {'title': title, 'image': image, 'id': id};
}
