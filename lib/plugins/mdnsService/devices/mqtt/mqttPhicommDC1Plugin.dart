//MqttPhicommDC1plug_:https://github.com/iotdevice/phicomm_dc1
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';

class MqttPhicommDC1PluginPage extends StatefulWidget {
  MqttPhicommDC1PluginPage({Key key, this.device}) : super(key: key);
  static final String modelName = "com.iotserv.devices.mqtt.zDC1";
  final PortService device;

  @override
  _MqttPhicommDC1PluginPageState createState() =>
      _MqttPhicommDC1PluginPageState();
}

class _MqttPhicommDC1PluginPageState extends State<MqttPhicommDC1PluginPage> {
  MqttServerClient client;
  final builder = MqttPayloadBuilder();
  String topic_sensor;
  String topic_state;

  //  总开关
  static const String plug_0 = "plug_0";

  static const String plug_1 = "plug_1";
  static const String plug_2 = "plug_2";
  static const String plug_3 = "plug_2";

  static const String power = "power";
  static const String current = "current";
  static const String voltage = "voltage";

  List<String> _switchKeyList = [plug_0, plug_1, plug_2, plug_3];
  List<String> _valueKeyList = [power, voltage, current];

//  bool _logLedStatus = true;
//  bool _wifiLedStatus = true;
//  bool _primarySwitchStatus = true;
  Map<String, dynamic> _status = Map.from({
    plug_0: 0,
    plug_1: 0,
    plug_2: 0,
    plug_3: 0,
    power: 0.0,
    voltage: 0.0,
    current: 0.0,
  });

  Map<String, String> _realName = Map.from({
    plug_0: "总开关",
    plug_1: "第一个插口",
    plug_2: "第二个插口",
    plug_3: "第三个插口",
    power: "功率",
    voltage: "电压",
    current: "电流",
  });

  @override
  void initState() {
    super.initState();
    topic_sensor = "device/zdc1/${widget.device.info["mac"]}/sensor";
    topic_state = "device/zdc1/${widget.device.info["mac"]}/state";
    _initMqtt();
    print("init iot devie List");
  }

  @override
  void dispose() {
    client.unsubscribeStringTopic(topic_sensor);
    client.unsubscribeStringTopic(topic_state);
    client.disconnect();
    super.dispose();
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
                    value: _status[pair] == 1,
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

  _initMqtt() async {
    client = MqttServerClient.withPort(
        widget.device.ip,
        widget.device.info.containsKey("client-id")
            ? widget.device.info["client-id"]
            : "",
        widget.device.port);
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(widget.device.info["client-id"])
        .startClean();
    client.connectionMessage = connMess;
    try {
      //用户名密码
      await client.connect(
          widget.device.info["username"], widget.device.info["password"]);
    } on MqttNoConnectionException catch (e) {
      Fluttertoast.showToast(msg: "MqttNoConnectionException:$e");
      client.disconnect();
    } on SocketException catch (e) {
      Fluttertoast.showToast(msg: "SocketException:$e");
      client.disconnect();
    }
    //TODO QoS
    client.subscribe(topic_sensor, MqttQos.atMostOnce);
    client.subscribe(topic_state, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      c.forEach((MqttReceivedMessage<MqttMessage> element) {
        final recMess = element.payload as MqttPublishMessage;
        final pt = MqttUtilities.bytesToStringAsString(recMess.payload.message);
        Fluttertoast.showToast(msg: 'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        //  TODO 通过获取的消息更新状态
        Map<String, dynamic> m = jsonDecode(pt);
        _switchKeyList.forEach((String key) {
          if (m.containsKey(key)) {
            setState(() {
              _status[key] = m[key]["on"];
            });
          }
        });
        _valueKeyList.forEach((String key) {
          if (m.containsKey(key)) {
            setState(() {
              _status[key] = m[key];
            });
          }
        });
      });
    });
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
    client.publishMessage(
        "device/zdc1/${widget.device.info["mac"]}/set",
        MqttQos.exactlyOnce,
        '{"mac":"${widget.device.info["mac"]}","$name":{"on":${_status[name] == 1 ? 0 : 1}}}'
            .codeUnits);
  }

  //mqtt的调用函数
  /// The subscribed callback
  void onSubscribed(MqttSubscription subscription) {
    Fluttertoast.showToast(msg: "onSubscribed:${subscription.topic}");
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    Fluttertoast.showToast(msg: "onDisconnected");
  }

  /// The successful connect callback
  void onConnected() {
    Fluttertoast.showToast(
        msg:
            'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  void pong() {
    Fluttertoast.showToast(
        msg: 'EXAMPLE::Ping response client callback invoked');
  }
}
