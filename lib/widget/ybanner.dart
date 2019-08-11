import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meimei/utils/screen_util.dart';

///封装的banner /图片,标题,指示器,点击回调
class YBanner extends StatefulWidget {
  final List<String> imgList; //图片列表
  final List<String> titleList; //标题,可能有
  ///点击事件
  final Function(int index) onClickIndex;

  YBanner(this.imgList, {this.titleList, this.onClickIndex});

  @override
  State<StatefulWidget> createState() => YBannerState();
}

class YBannerState extends State<YBanner> with AutomaticKeepAliveClientMixin {
  int _bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ///这里加上判断,否则会有异常log,但是页面不会显示错误
    if (widget.imgList.length == 0) {
      return SizedBox();
    } else {
      return bannerView();
    }
  }

  Widget bannerView() {
    return GestureDetector(
      onTap: () {
        if (null != widget.onClickIndex) {
          widget.onClickIndex(_bannerIndex);
        }
      },
      child: Stack(
        children: <Widget>[
          carouselView(),
          bannerPoint(),
        ],
      ),
    );
  }

  ///banner除指示器外的内容
  Widget carouselView() {
    return CarouselSlider(
        height: 130,
        aspectRatio: 2.0,
        viewportFraction: 1.0,
        //一屏显示一个
        autoPlay: true,
        enlargeCenterPage: false,
        pauseAutoPlayOnTouch: Duration(milliseconds: 400),
        onPageChanged: (index) {
          setState(() {
            _bannerIndex = index;
          });
        },
        items: widget.imgList
            .map(
              (url) => Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    width: YScreenUtil.getWinWidth(),
                    imageUrl: url,
                    fit: BoxFit.cover,
                  ),

                  ///标题
                  titleView()
                ],
              ),
            )
            .toList());
  }

  ///banner指示器
  Widget bannerPoint() {
    return Positioned(
        right: 30,
        bottom: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ymap<Widget>(
            widget.imgList,
            (index, url) {
              if (_bannerIndex == index) {
                return Container(
                  width: 10.0,
                  height: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white),
                );
              } else {
                return Container(
                  width: 4.0,
                  height: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                );
              }
            },
          ),
        ));
  }

  ///标题
  Widget titleView() {
    if (null == widget.titleList ||
        (null != widget.titleList && widget.titleList.length < 1)) {
      return SizedBox();
    } else {
      return Positioned(
          bottom: 18,
          right: 10,
          left: 16,
          child: Text(
            widget.titleList[_bannerIndex],
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
            softWrap: true,
          ));
    }
  }

  List<T> ymap<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  bool get wantKeepAlive => true;
}
