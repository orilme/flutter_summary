import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/menu/tab_bar/riki_scaled_tab_bar.dart';
import 'package:flutter_demo/base/utils/screen_util/flutter_screenutil.dart';

class MenuPage extends StatefulWidget {
  final bool keepAlive;
  const MenuPage({this.keepAlive = true});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    this.tabController = TabController(length: 4, vsync: this);
    this.tabController.addListener(() {
      print(this.tabController.toString());
      print(this.tabController.index);
      print(this.tabController.length);
      print(this.tabController.previousIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('菜单demo')),
      body: Center(
        child: Column(
          children: [_buildTabBar(), SizedBox(height: 3.h), Expanded(child: _buildContentBody())],
        ),
      ),
    );
  }

  ///一级分类
  Widget _buildTabBar() {
    return Container(
      height: 50.w,
      width: 375.w,
      // child: TabBar(
      //   controller: this.tabController,
      //   labelColor: Colors.red,
      //   tabs: <Widget>[
      //     Tab(text: '标题1'),
      //     Tab(text: '标题2'),
      //     Tab(text: '标题3'),
      //     Tab(text: '标题4'),
      //   ],
      // ),
      child: RikiScaledTabBar.normal(
        isScrollable: true,
        labelColor: const Color(0xFF111111),
        textList: ["标题1", "标题2", "标题3", "标题4"],
        controller: tabController,
      ),
    );
  }

  Widget _buildContentBody() {
    final List<Widget> children = [MallTabPage(index: 0), MallTabPage(index: 1), MallTabPage(index: 2), MallTabPage(index: 3)];
    return TabBarView(controller: tabController, children: children);
  }

  @override
  void initData(BuildContext context) {}

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class MallTabPage extends StatefulWidget {
  final int index;
  const MallTabPage({Key? key, required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MallTabPageState();
  }
}

class _MallTabPageState extends State<MallTabPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color(0xFFF7F7F7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _build2LvlList(),
          Expanded(
              child: Container(
            color: Colors.blue,
          ) //LeafCategoryZoneWidget(index: widget.index,)
              ),
        ],
      ),
    );
  }

  ///二级分类
  Widget _build2LvlList() {
    return Container(
      width: 98.w,
      child: Column(
        children: [
          SecondLvlListWidget(index: widget.index)
          // Expanded(child: Selector<MallCenterVM, int>(
          //   builder: (ctx, showTopRightCorner, child) {
          //     return Container(
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: parentVM.last2LvlIndexSelected(widget.index) ? BorderRadius.only(topRight: Radius.circular(8.w)) : null
          //       ),
          //     );
          //   },
          //   selector: (ctx, model) {
          //     return model.lvl2ListChecker;
          //   },
          // )),
        ],
      ),
    );
  }

  @override
  void initData(BuildContext context) {}

  @override
  bool get wantKeepAlive => true;
}

class SecondLvlListWidget extends StatefulWidget {
  ///属于第几个一级类目
  final int index;

  const SecondLvlListWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SecondLvlListWidgetState();
  }
}

class _SecondLvlListWidgetState extends State<SecondLvlListWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: List.generate(
          5,
          (index) => GestureDetector(
                onTap: () {},
                child: SecondLvlItemWidget(
                  index: index,
                ),
              )),
    );
  }

  @override
  void initData(BuildContext context) {}
}

class SecondLvlItemWidget extends StatefulWidget {
  ///属于二级类目的第几个
  final int index;

  const SecondLvlItemWidget({Key? key, required this.index}) : super(key: key);

  static RRect _shaderRect = RRect.fromRectAndCorners(
    Rect.fromLTWH(0, 0, 3.w, 22.w),
    bottomRight: Radius.circular(5.w),
    bottomLeft: Radius.circular(0),
    topLeft: Radius.circular(0),
    topRight: Radius.circular(5.w),
  );

  @override
  State<StatefulWidget> createState() {
    return _SecondLvlItemWidgetState();
  }
}

class _SecondLvlItemWidgetState extends State<SecondLvlItemWidget> {
  ///是否是选中的
  bool isChosen(int value) => value == widget.index;

  ///是否紧邻选中的
  bool isNearChosen(int index) => (widget.index - index).abs() == 1;

  final TextStyle selectedStyle = TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w600);

  final TextStyle unSelectedStyle = TextStyle(color: const Color(0xFF666666), fontSize: 14.sp);

  BorderRadius getBorderRadius(int currentIndex) {
    if (isNearChosen(currentIndex)) {
      switch (widget.index - currentIndex) {
        case -1:
          return BorderRadius.only(bottomRight: Radius.circular(8.w));
        case 1:
          return BorderRadius.only(topRight: Radius.circular(8.w));
      }
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98.w,
      height: 50.w,
      decoration: BoxDecoration(
          // color: isChosen(value) ? Color(0xFFF7F7F7) : Colors.white,
          // borderRadius: getBorderRadius(value)
          color: Color(0xFFF7F7F7),
          borderRadius: getBorderRadius(widget.index)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // if(isChosen(value))
          //   Positioned(
          //       left: 0, top: 14.w,
          //       child: VerticalLadderShapeIndicator(rect: SecondLvlItemWidget._shaderRect)),
          SizedBox(
            width: 70.w,
            child: Text('哈哈哈哈', maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: selectedStyle),
          ),
        ],
      ),
    );
  }

  @override
  void initData(BuildContext context) {
    // TODO: implement initData
  }
}
