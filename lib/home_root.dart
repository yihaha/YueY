import 'package:flutter/material.dart';
import 'package:meimei/constant/ycolors.dart';

import 'leisure.dart';
import 'meitu.dart';

//首页根布局,包含首页和其他页
class HomeRootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeRootPageState();
}

class HomeRootPageState extends State<HomeRootPage> {
  List<String> _tabTextList = ['美图', '休闲'];
  List<IconData> _tabIconList = [Icons.face, Icons.free_breakfast];
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          MeiTu(),
          Leisure(),
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: _getTabIcon(0), title: _getTabText(0)),
          BottomNavigationBarItem(icon: _getTabIcon(1), title: _getTabText(1)),
        ],
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
            print('当前点击索引 $_tabIndex');
          });
        },
      ),
    );
  }

  //切换tab文字,改变颜色
  Text _getTabText(int index) {
    if (index == _tabIndex) {
      return Text(
        _tabTextList[index],
        style: TextStyle(color: AppColors.PRIMARY_TLZ_COLOR),
      );
    } else {
      return Text(
        _tabTextList[index],
        style: TextStyle(color: IconTheme.of(context).color),
      );
    }
  }

  //切换tab图片,改变颜色
  Icon _getTabIcon(int index) {
    if (index == _tabIndex) {
      return Icon(
        _tabIconList[index],
        color: AppColors.PRIMARY_TLZ_COLOR,
      );
    } else {
      return Icon(
        _tabIconList[index],
        color: IconTheme.of(context).color,
      );
    }
  }
}
