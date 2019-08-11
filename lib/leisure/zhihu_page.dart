import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meimei/bean/zhihu.dart';
import 'package:meimei/constant/constant.dart';
import 'package:meimei/http/http_api.dart';
import 'package:meimei/utils/route_util.dart';
import 'package:meimei/utils/screen_util.dart';
import 'package:meimei/widget/ybanner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ZhiHuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ZhihuState();
}

class ZhihuState extends State<ZhiHuPage> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true; //加载中...
  RefreshController _mRefreshController;
  ScrollController controller = ScrollController();
  bool isShowFloatButton = false;

  ///存储banner数据
  List<ZhiHuBanner> _banners = [];

  ///条目
  List<ZHItemBean> _zhiHlist = [];

//  String _currDate = DateUtil.formatDate(DateTime.now(), format: 'yyyyMMdd');
  DateTime _currDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    ///默认不显示回首页按钮
    _mRefreshController = RefreshController();
    controller.addListener(() {
      var offset = controller.offset;
      var wHeight = YScreenUtil.getWinHeight();
//      print('滑动位置 $offset ');
//      \n 屏幕高度 $wHeight');
      ///查看log,发现这个位置相对比较合适
      if (offset < wHeight / 3 && isShowFloatButton) {
        setState(() {
          isShowFloatButton = false;
        });
      } else if (offset > wHeight / 3 && !isShowFloatButton) {
        setState(() {
          isShowFloatButton = true;
        });
      }
    });

    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isLoading,
          child: SmartRefresher(
            header: Platform.isAndroid
                ? MaterialClassicHeader(
                    ///下拉状态的颜色
                    color: Theme.of(context).primaryColor,
                  )
                : ClassicHeader(),
            onRefresh: toRefresh,
            onLoading: getMore,
            controller: _mRefreshController,
            enablePullUp: true,
            child: listviewBuild(),
          ),
        ),
        yFloatingActionButton(),
        Offstage(
          offstage: !_isLoading,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        )
      ],
    );
  }

  ///回到顶部按钮
  Widget yFloatingActionButton() {
    return Positioned(
        right: 20,
        bottom: 60,

        ///加个淡入淡出效果
        child: AnimatedOpacity(
            opacity: isShowFloatButton ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: FloatingActionButton(
              heroTag: 'zhihu_up_first',
              onPressed: () {
                ///显示的时候才响应点击事件
                if (isShowFloatButton) {
                  ///回到顶部
                  controller.animateTo(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.keyboard_arrow_up),
            )));
  }

  void initData() async {
//    var data = await getBanner();
    var data = await HttpApi.getZhiHuBanner();
    List<ZhiHuBanner> banners = data['top_stories']
        .map<ZhiHuBanner>((bean) => ZhiHuBanner.fromJson(bean))
        .toList();

    var ddd = data['stories'];
    print(ddd.toString());

    if (_isLoading) {
      setState(() {
        _isLoading = false;
        _banners.addAll(banners);
        _zhiHlist.addAll(formatZhItem(data));
      });
    }

    ///当前日期的item
    String date = DateUtil.formatDate(_currDate, format: 'yyyyMMdd');
    var data2 = await getZHItem(date: date);
    if (_isLoading) {
      setState(() {
        _isLoading = false;
        _zhiHlist.addAll(formatZhItem(data2));
      });
    }
  }

  ///获取banner列表
  Future getBanner() async {
    var data = await HttpApi.getZhiHuBanner();
    List<ZhiHuBanner> banners = data['top_stories']
        .map<ZhiHuBanner>((bean) => ZhiHuBanner.fromJson(bean))
        .toList();
    return banners;
  }

  ///下拉刷新
  void toRefresh() async {
    var data = await HttpApi.getZhiHuBanner();
    List<ZhiHuBanner> banners = data['top_stories']
        .map<ZhiHuBanner>((bean) => ZhiHuBanner.fromJson(bean))
        .toList();

    await Future.delayed(Duration(milliseconds: 1000));
    _mRefreshController.refreshCompleted();
    setState(() {
      _banners = banners;
      _zhiHlist = formatZhItem(data);
    });

    ///当前日期的item
    _currDate = DateTime.now();
    String date = DateUtil.formatDate(_currDate, format: 'yyyyMMdd');
    var data2 = await getZHItem(date: date);
    setState(() {
      _isLoading = false;
      _zhiHlist.addAll(formatZhItem(data2));
    });
  }

  ///上拉加载更多
  void getMore() async {
    _currDate = _currDate.add(Duration(days: -1));
    String date = DateUtil.formatDate(_currDate, format: 'yyyyMMdd');
    print('more_date:${_currDate.add(Duration(days: -1))}  :  $date');
    var data = await getZHItem(date: date);
    await Future.delayed(Duration(milliseconds: 1000));
    _mRefreshController.loadComplete();
    setState(() {
      _zhiHlist.addAll(formatZhItem(data));
    });
  }

  Future getZHItem({String date}) async {
    var data = await HttpApi.getZhiHuItem(date: date);
    return data;
  }

  ///统一格式化item
  List<ZHItemBean> formatZhItem(var data) {
    ///最新消息接口带有条目
    List<ZHItemBean> zhiHList = [];
    var ddd = data['stories'];
    ddd.map((bean) {
//      print(bean['images'][0].toString());
      bean['image'] = bean['images'][0].toString();
//      print('测试图片链接 ${bean['image']}');
      zhiHList.add(ZHItemBean.fromJson(bean));
    }).toList();
    return zhiHList;
  }

  ///ListView
  ListView listviewBuild() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return YBanner(
            _banners.map((banner) => banner.image).toList(),
            titleList: _banners.map((banner) => banner.title).toList(),
            onClickIndex: (index) {
              ///跳转到webview
              RouteUtil.routeToWeb(
                  context, Constant.ZhiHu_Web_Url + '${_banners[index].id}',
                  title: _banners[index].title);
            },
          );
        } else {
          return zhiHItemView(index - 1);
        }
      },
      controller: controller,
      itemCount: _zhiHlist.length + 1,
    );
  }

  ///具体条目
  Widget zhiHItemView(int index) {
//    print('具体条目索引  $index');
    return InkWell(
      onTap: () {
        ///跳转到webview
        RouteUtil.routeToWeb(
            context, Constant.ZhiHu_Web_Url + '${_zhiHlist[index].id}',
            title: _zhiHlist[index].title);
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          _zhiHlist[index].title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          softWrap: true,
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        CachedNetworkImage(
                          width: 90,
                          height: 80,
                          imageUrl: _zhiHlist[index].image,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              ///添加分割线
              Divider(
                color: Colors.grey,
                height: 0.5,
              )
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
