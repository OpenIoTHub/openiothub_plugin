//MqttPhicommzA1plug_:https://gitee.com/a2633063/zA1
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';

import '../../../mdnsService/commWidgets/info.dart';

class MqttPhicommzA1PluginPage extends StatefulWidget {
  MqttPhicommzA1PluginPage({required Key key, required this.device})
      : super(key: key);
  static final String modelName = "com.iotserv.devices.mqtt.zA1";
  final PortService device;

  @override
  _MqttPhicommzA1PluginPageState createState() =>
      _MqttPhicommzA1PluginPageState();
}

class _MqttPhicommzA1PluginPageState extends State<MqttPhicommzA1PluginPage> {
  late MqttServerClient client;
  late String topic_state;
  late String topic_set;

  //  总开关
  static const String on = "on";

  static const String speed = "speed";

  List<String> _keyList = [on, speed];

  Map<String, dynamic> _status = Map.from({
    on: 0,
    speed: 0,
  });

  Map<String, String> _realName = Map.from({
    on: "开关",
    speed: "速度",
  });

  @override
  void initState() {
    super.initState();
    topic_state = "device/za1/${widget.device.info["mac"]}/state";
    topic_set = "device/za1/${widget.device.info["mac"]}/set";
    _initMqtt();
    print("init iot devie List");
  }

  @override
  void dispose() {
    client.unsubscribeStringTopic(topic_state);
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.addAll(_keyList);
    final tiles = _result.map(
      (pair) {
        switch (pair) {
          case on:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Switch(
                    onChanged: (bool value) {
                      _changeSwitchStatus(pair, value);
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
                  Text(_realName[pair]!),
                  SeekBar(
                      indicatorRadius: 0.0,
                      progresseight: 5,
                      hideBubble: false,
                      alwaysShowBubble: true,
                      bubbleRadius: 14,
                      bubbleColor: Colors.purple,
                      bubbleTextColor: Colors.white,
                      bubbleTextSize: 14,
                      bubbleMargin: 4,
                      bubbleInCenter: true,
                      onValueChanged: (v) {
                        _changeProgressStatus(pair, v.value.toInt());
                      }),
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
        title: Text(widget.device.info["name"]!),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.green,
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
            ? widget.device.info["client-id"]!
            : "",
        widget.device.port);
    client.autoReconnect = true;
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.onAutoReconnect = onAutoReconnect;
    client.onAutoReconnected = onAutoReconnected;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(widget.device.info["client-id"]!)
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
    //QoS
    client.subscribe(topic_state, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      c.forEach((MqttReceivedMessage<MqttMessage> element) {
        final recMess = element.payload as MqttPublishMessage;
        final pt =
            MqttUtilities.bytesToStringAsString(recMess.payload.message!);
        // Fluttertoast.showToast(
        //     msg:
        //         'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        //  通过获取的消息更新状态
        Map<String, dynamic> m = jsonDecode(pt);
        _keyList.forEach((String key) {
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
    // 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  _changeSwitchStatus(String name, bool value) async {
    final builder = MqttPayloadBuilder();
    builder.addString(
        '{"mac":"${widget.device.info["mac"]}","$name":${value ? 1 : 0}}');
    client.publishMessage(topic_set, MqttQos.atLeastOnce, builder.payload!);
  }

  _changeProgressStatus(String name, int value) async {
    final builder = MqttPayloadBuilder();
    builder
        .addString('{"mac":"${widget.device.info["mac"]}","$name":${value}}');
    client.publishMessage(topic_set, MqttQos.atLeastOnce, builder.payload!);
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

  void onAutoReconnect() {
    Fluttertoast.showToast(msg: '重连mqtt...');
  }

  void onAutoReconnected() {
    Fluttertoast.showToast(msg: '重连mqtt服务器成功！');
  }
}
