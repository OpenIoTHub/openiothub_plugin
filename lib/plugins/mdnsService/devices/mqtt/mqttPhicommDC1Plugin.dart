//MqttPhicommDC1plug_:https://github.com/iotdevice/phicomm_dc1
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';

class MqttPhicommDC1PluginPage extends StatefulWidget {
  MqttPhicommDC1PluginPage({Key key, this.device}) : super(key: key);
  static final String modelName = "com.iotserv.devices.mqtt.zDC1";
  final PortService device;

  @override
  _MqttPhicommDC1PluginPageState createState() => _MqttPhicommDC1PluginPageState();
}

class _MqttPhicommDC1PluginPageState extends State<MqttPhicommDC1PluginPage> {
  //  总开关
  static const String plug_0 = "plug_0";

  static const String plug_1 = "plug_1";
  static const String plug_2 = "plug_2";
  static const String plug_3 = "plug_2";

  static const String Power = "Power";
  static const String Current = "Current";
  static const String Voltage = "Voltage";

  List<String> _switchKeyList = [
    plug_0,
    plug_1,
    plug_2,
    plug_3
  ];
  List<String> _valueKeyList = [
    Power,
    Voltage,
    Current
  ];

//  bool _logLedStatus = true;
//  bool _wifiLedStatus = true;
//  bool _primarySwitchStatus = true;
  Map<String, dynamic> _status = Map.from({
    plug_0: 0,
    plug_1: 0,
    plug_2: 0,
    plug_3: 0,
    Power: 0.0,
    Voltage: 0.0,
    Current: 0.0,
  });

  Map<String, String> _realName = Map.from({
    plug_0: "总开关",
    plug_1: "第一个插口",
    plug_2: "第二个插口",
    plug_3: "第三个插口",
    Power: "功率",
    Voltage: "电压",
    Current: "电流",
  });

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.addAll(_switchKeyList);
    _result.addAll(_valueKeyList);
    final tiles = _result.map(
      (pair) {
        switch (pair) {
          case plug_0:
          case plug_1:
          case plug_2:
          case plug_3:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]),
                  Switch(
                    onChanged: (_) {
                      _changeSwitchStatus(pair);
                    },
                    value: _status[pair],
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            );
            break;
          default:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]),
                  Text(":"),
                  Text(_status[pair].toString()),
                ],
              ),
            );
            break;
        }
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info["name"]),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _getCurrentStatus();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  _getCurrentStatus() async {
    String url = "http://${widget.device.ip}:${widget.device.port}/status";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
//    同步状态到界面
    if (response.statusCode == 200) {
      _switchKeyList.forEach((switchValue) {
        setState(() {
          _status[switchValue] =
              jsonDecode(response.body)[switchValue] == 1 ? true : false;
        });
      });
      _valueKeyList.forEach((value) {
        setState(() {
          _status[value] = jsonDecode(response.body)[value];
        });
      });
    } else {
      print("获取状态失败！");
    }
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
          );
        },
      ),
    );
  }

  _changeSwitchStatus(String name) async {
    String url;
    if (_status[name]) {
      url = "http://${widget.device.ip}:${widget.device.port}/switch?off=$name";
    } else {
      url = "http://${widget.device.ip}:${widget.device.port}/switch?on=$name";
    }
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
    _getCurrentStatus();
  }
}
