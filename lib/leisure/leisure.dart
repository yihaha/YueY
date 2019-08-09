import 'package:flutter/material.dart';
import 'package:meimei/leisure/zhihu_page.dart';
import 'package:meimei/utils/screen_util.dart';

class Leisure extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeisureState();
}

class LeisureState extends State<Leisure> with SingleTickerProviderStateMixin {
  List<String> _tabTitleList = ['知乎日报', 'Flutter动态', '玩Android'];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitleList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: _tabTitleList
              .map((st) => Tab(
                    text: st,
                  ))
              .toList(),

          ///设置选中/非选中字体大小不同,可以有动画效果
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),
      body: TabBarView(
        children: _tabTitleList.map((st) {
          if (st == '知乎日报') {
            return ZhiHuPage();
          } else if (st == 'Flutter动态') {
            return ZhiHuPage();
          } else {
            return ZhiHuPage();
          }
        }).toList(),
        controller: _tabController,
      ),
    );
  }
}
