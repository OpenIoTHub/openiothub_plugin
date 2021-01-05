import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';

class MDNSInfoPage extends StatelessWidget {
  MDNSInfoPage({Key key, this.portConfig}) : super(key: key);
  PortConfig portConfig;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设备信息
    final List _result = [];
    _result.add("mDNS信息:${portConfig.mDNSInfo}");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('设备信息'),
      ),
      body: ListView(children: divided),
    );
  }
}
