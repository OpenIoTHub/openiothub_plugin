import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/gateway/gateway.pb.dart';
import 'package:openiothub_grpc_api/proto/gateway/gateway.pbgrpc.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/l10n/generated/openiothub_plugin_localizations.dart';

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
  OpenIoTHubPluginLocalizations? localizations;

  @override
  void initState() {
    _listAvailableServer();
    _checkAddable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    localizations = OpenIoTHubPluginLocalizations.of(context);
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
          title: Text(localizations!.select_server_for_gateway),
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
                  // color: Colors.white,
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
      showToast(localizations!.add_gateway_success);
    } catch (exception) {
      showToast("${localizations!.login_failed}：${exception}");
    }
  }

  _confirmAdd(ServerInfo serverInfo) {
    if (!_addable) {
      showToast(localizations!.gateway_already_added);
      return;
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(localizations!.confirm_gateway_connect_this_server),
                content: SizedBox.expand(
                  child: Text("${serverInfo.serverHost}"),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations!.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(localizations!.add),
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
      showToast("${localizations!.add_gateway_failed}：${exception}");
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
      showToast("${localizations!.get_gateway_login_status_failed}：$exception");
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
