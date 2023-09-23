import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gateway_grpc_api/pb/service.pb.dart';
import 'package:gateway_grpc_api/pb/service.pbgrpc.dart';
import 'package:iot_manager_grpc_api/pb/gatewayManager.pb.dart';
import 'package:iot_manager_grpc_api/pb/serverManager.pb.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';

import '../../mdnsService/commWidgets/info.dart';

class Gateway extends StatefulWidget {
  Gateway({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.gateway";
  final PortService device;

  @override
  createState() => GatewayState();
}

class GatewayState extends State<Gateway> {
  //是否可以添加 true：可以添加 false：不可以添加
  bool _addable = true;
  List<ServerInfo> _availableServerList = [];

  @override
  Future<void> initState() async {
    _listAvailableServer();
    _checkAddable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _availableServerList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.send_rounded),
              ),
              Expanded(
                  child: Text(
                "${pair.name}(${pair.serverHost})",
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            _confirmAdd(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("选择本网关需要连接的服务器"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.info,
                  color: Colors.green,
                ),
                onPressed: () {
                  _info();
                }),
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  //刷新端口列表
                  _listAvailableServer();
                }),
          ],
        ),
        body: ListView(
          children: divided,
        ));
  }

  Future _addToMySessionList(String token, name) async {
    SessionConfig config = SessionConfig();
    config.token = token;
    config.description = name;
    try {
      await SessionApi.createOneSession(config);
      Fluttertoast.showToast(msg: "添加网关成功！");
    } catch (exception) {
      Fluttertoast.showToast(msg: "登录失败：${exception}");
    }
  }

  _confirmAdd(ServerInfo serverInfo) {
    if (!_addable) {
      Fluttertoast.showToast(msg: "该网关已经被其他用户添加，请联系该网关管理员或者清空网关配置并重启网关");
      return;
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("确认添加本网关到此服务器？"),
                content: Text("${serverInfo.serverHost}"),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("添加"),
                    onPressed: () {
                      _addToMyAccount(serverInfo);
                    },
                  )
                ]));
  }

  //已经确认过可以添加，添加到我的账号
  _addToMyAccount(ServerInfo serverInfo) async {
    try {
      // 从服务器自动生成一个网关
      GatewayInfo gatewayInfo =
          await GatewayManager.GenerateOneGatewayWithServerUuid(
              serverInfo.uuid);
      //使用网关信息将网关登录到服务器
      LoginResponse loginResponse =
          await GatewayLoginManager.LoginServerByToken(
              gatewayInfo.gatewayJwt, widget.device.ip, widget.device.port);
//    自动添加到我的列表
      if (loginResponse.loginStatus) {
        //将网关映射到本机
        _addToMySessionList(gatewayInfo.openIoTHubJwt, gatewayInfo.name)
            .then((value) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (exception) {
      Fluttertoast.showToast(msg: "添加网关失败：${exception}");
    }
  }

  Future<void> _listAvailableServer() async {
    ServerInfoList serverInfoList = await ServerManager.GetAllServer();
    setState(() {
      _availableServerList = serverInfoList.serverInfoList;
    });
  }

  //获取网关的登录状态判断是否可以被新用户添加
  Future _checkAddable() async {
    try {
      LoginResponse loginResponse =
          await GatewayLoginManager.CheckGatewayLoginStatus(
              widget.device.ip, widget.device.port);
      _addable = !loginResponse.loginStatus;
    } catch (exception) {
      Fluttertoast.showToast(msg: "获取网关的登录状态异常：$exception");
    }
  }

  _info() async {
    // TODO 设备信息
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
}
