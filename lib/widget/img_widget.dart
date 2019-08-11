import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meimei/utils/screen_util.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

///图片浏览页面
class ImgPage extends StatefulWidget {
  final List<String> urlList;
  final List<String> titleList;
  final int index;

  ImgPage(this.urlList, this.titleList, {this.index: 0});

  @override
  State<StatefulWidget> createState() => ImgPageState();
}

class ImgPageState extends State<ImgPage> {
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    _currIndex = widget.index;
    ScreenUtil.updateStatusBarStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.titleList[_currIndex],
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            print('图片索引 $index');
            print('_currIndex图片索引 $_currIndex');
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.urlList[index]),
              heroTag: widget.urlList[index],

              ///默认大小
              initialScale: PhotoViewComputedScale.contained * 0.98,

              ///最小界限
              minScale: PhotoViewComputedScale.contained * 0.15,
            );
          },
          itemCount: widget.urlList.length,
          loadingChild: CupertinoActivityIndicator(),
          backgroundDecoration: BoxDecoration(color: Colors.white),

          ///首次进入设置对应图片
          pageController: PageController(initialPage: _currIndex),
          onPageChanged: (index) {
            setState(() {
              _currIndex = index;
            });
          },
        ),
      ),
    );
  }
}
