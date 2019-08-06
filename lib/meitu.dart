import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  List _tuList = [];
  bool _isOneColumn = false; //默认两列

  @override
  void initState() {
    super.initState();
    _mRefreshController = RefreshController();
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
    return Container(
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isLoading,
            child: SmartRefresher(
              onRefresh: toRefresh,
              onLoading: getMore,
              controller: _mRefreshController,
              enablePullUp: true,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _isOneColumn ? 1 : 2,
                      childAspectRatio: 2 / (_isOneColumn ? 3 : 3),
                      crossAxisSpacing: 8),
                  itemCount: _tuList.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    var itemBean = _tuList[index];
                    return GestureDetector(
                        onTap: () {
                          print('点击图片');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _tuItemView(itemBean),
                        ));
                  }),
            ),
          ),
        ],
      ),
    );
  }

  ///下拉刷新
  void toRefresh() async {
    _currPage = 1;
    var tuList = await _getData();
    _mRefreshController.loadComplete();
    setState(() {
      _tuList = tuList;
    });
  }

  ///上拉加载更多
  void getMore() async {
    _currPage++;
    var tuList = await _getData();
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

  @override
  bool get wantKeepAlive => true;
}
