import 'package:flutter/material.dart';

class ExpansionPanelListPage extends StatefulWidget {
  @override
  _ExpansionPanelListPageState createState() => _ExpansionPanelListPageState();
}

class _ExpansionPanelListPageState extends State<ExpansionPanelListPage> {
  List<bool> dataList = List.generate(20, (index) => false).toList();

  _buildExpansionPanelList() {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          dataList[index] = !isExpanded;
        });
      },
      children: dataList.map((value) {
        return ExpansionPanel(
          isExpanded: value,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text('ExpansionPanelList'),
            );
          },
          body: Container(
            height: 100,
            color: Colors.greenAccent,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ExpansionPanelList"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: _buildExpansionPanelList(),
          ),
        ),
    );
  }

}
