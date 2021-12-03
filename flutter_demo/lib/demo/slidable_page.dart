import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidablePage extends StatefulWidget {
  @override
  _SlidablePageState createState() => _SlidablePageState();
}

class _SlidablePageState extends State<SlidablePage> {
  List<int> list = [1,2,3,4,5,6,7,8,9];
  final SlidableController slidableController = SlidableController();

  _showSnackBar (String val, int? idx) {
    print("_showSnackBar---${val}---${idx}");
    if (idx != null) {
      setState(() {
        list.removeAt(idx);
      });
    }
  }

  _showSnack (BuildContext context, type) {
    print("_showSnack---${type}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('侧滑删除'),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(index.toString()),
              controller: slidableController,
              actionPane: SlidableScrollActionPane(), // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
              actionExtentRatio: 0.20, // 侧滑按钮所占的宽度
              enabled: true,// 是否启用侧滑 默认启用
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (actionType) {
                  _showSnack(
                      context,
                      actionType == SlideActionType.primary ? 'Dismiss Archive' : 'Dimiss Delete'
                  );
                  setState(() {
                    list.removeAt(index);
                  });
                },
                // onWillDismiss: (actionType) {
                //
                // },
              ),
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Text('${list[index]}'),
                    foregroundColor: Colors.white,
                  ),
                  title: Text('Tile n°${list[index]}'),
                  subtitle: Text('SlidableDrawerDelegate'),
                ),
              ),
              /// 配置左侧
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Archive',
                  color: Colors.blue,
                  icon: Icons.archive,
                  onTap: () => print('2222'),
                  closeOnTap: false,
                ),
                IconSlideAction(
                  caption: 'Share',
                  color: Colors.indigo,
                  icon: Icons.share,
                  onTap: () => _showSnackBar('Share', null),
                ),
              ],
              /// 配置右侧
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'More',
                  color: Colors.black45,
                  icon: Icons.more_horiz,
                  onTap: () => _showSnackBar('More', null),
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  closeOnTap: true,
                  onTap: () => _showSnackBar('Delete', index),
                ),
              ],
            );
          }
      ),
    );
  }
}
