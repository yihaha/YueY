import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meimei/utils/route_util.dart';
import 'package:meimei/utils/screen_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bean/meitu.dart';
import 'http/http_api.dart';

class MeiTu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MeiTuState();
}

class MeiTuState extends State<MeiTu> with AutomaticKeepAliveClientMixin {
  int _currPage = 1;
  bool _isLoading = true;
  RefreshController _mRefreshController;
  ScrollController controller = ScrollController();
  List _tuList = [];
  bool _isOneColumn = false; //默认两列
  var isShowFloatButton = false;
  double yNavigationShow = 0; //控制顶部导航栏是否显示1显示,0隐藏

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () {
      ScreenUtil.updateStatusBarStyle(SystemUiOverlayStyle.dark);
    });

    ///默认不显示回首页按钮
    _mRefreshController = RefreshController();
    controller.addListener(() {
      var offset = controller.offset;
      var wHeight = window.physicalSize.height;
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

      ///控制导航栏的显示与隐藏
      if (offset <= kToolbarHeight + MediaQuery.of(context).padding.top) {
        ///隐藏
        setState(() {
          ScreenUtil.updateStatusBarStyle(SystemUiOverlayStyle.dark);
          yNavigationShow = 0;
        });
      } else {
        setState(() {
          ScreenUtil.updateStatusBarStyle(SystemUiOverlayStyle.light);
          yNavigationShow = 1;
        });
      }
    });

    initData();
  }

  void initData() async {
    var list = await _getData();
    setState(() {
      _tuList.addAll(list);
      _isLoading = false;
    });
  }

//网络请求数据
  Future _getData() async {
    var data = await HttpApi.getMeiTuData(_currPage);
    print('获取的数据' + data['results'].toString());
    var meiTuList = data['results']
        .map<MeiTuBean>((item) => MeiTuBean.fromJson(item))
        .toList();
    print('转换后的shuju' + meiTuList[0].desc);
    return meiTuList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Stack(
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
              child: GridView.builder(
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _isOneColumn ? 1 : 2,
                      childAspectRatio: 3 / (_isOneColumn ? 3.5 : 4),
                      crossAxisSpacing: 8),
                  itemCount: _tuList.length,
                  padding: EdgeInsets.fromLTRB(
                      8, ScreenUtil.getStatusHeight(), 8, 8),
                  itemBuilder: (context, index) {
                    var itemBean = _tuList[index];
                    return GestureDetector(
                        onTap: () {
                          RouteUtil.routeToImg(
                              context,
                              _tuList.map<String>((bean) {
                                return bean.url;
                              }).toList(),
                              _tuList.map<String>((bean) {
                                return bean.desc;
                              }).toList(),
                              position: index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _tuItemView(itemBean),
                        ));
                  }),
            ),
          ),
          yFloatingActionButton(),
          yNavigationBar(),
        ],
      ),
    );
  }

  ///下拉刷新
  void toRefresh() async {
    _currPage = 1;
    var tuList = await _getData();
    await Future.delayed(Duration(milliseconds: 1000));
    _mRefreshController.refreshCompleted();
    setState(() {
      _tuList = tuList;
    });
  }

  ///上拉加载更多
  void getMore() async {
    _currPage++;
    var tuList = await _getData();
    await Future.delayed(Duration(milliseconds: 1000));
    _mRefreshController.loadComplete();
    setState(() {
      _tuList.addAll(tuList);
    });
  }

  ///图片item
  Widget _tuItemView(item) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: CachedNetworkImage(
            imageUrl: item.url,
            fit: BoxFit.cover,
          )),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
//                width: MediaQuery.of(context).size.width,
                width: window.physicalSize.width / 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                  child: Text(
                    item.desc,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ],
      ),
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

  ///顶部导航
  Widget yNavigationBar() {
    return AnimatedOpacity(
      opacity: yNavigationShow,
      duration: Duration(milliseconds: 300),
      child: Container(
          color: Theme.of(context).primaryColor,

          ///appbar高度+状态栏高度
          height:
              kToolbarHeight + MediaQueryData.fromWindow(window).padding.top,
//          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),

//          height: 70,
          padding: EdgeInsets.only(top: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '福利',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        right: 16,
                        top: 1,
                        bottom: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (yNavigationShow == 1) {
                              setState(() {
                                _isOneColumn = !_isOneColumn;
                              });
                            }
                          },
                          child: Icon(Icons.view_quilt, color: Colors.white),
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _mRefreshController.dispose();
    controller.dispose();
    super.dispose();
  }
}
