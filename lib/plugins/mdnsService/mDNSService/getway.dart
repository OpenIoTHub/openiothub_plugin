import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gateway_grpc_api/pb/service.pb.dart';
import 'package:gateway_grpc_api/pb/service.pbgrpc.dart';
import 'package:iot_manager_grpc_api/pb/gatewayManager.pb.dart';
import 'package:openiothub_api/api/GateWay/GatewayLoginManager.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';

class Gateway extends StatefulWidget {
  Gateway({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.gateway";
  final PortService device;

  @override
  createState() => GatewayState();
}

class GatewayState extends State<Gateway> {
  //设备信息
  final List _std_key = [
    "name",
    "model",
    "mac",
    "id",
    "author",
    "email",
    "home-page",
    "firmware-respository",
    "firmware-version"
  ];
  final List<String> _result = [];
  List<Widget> tilesList;

  @override
  Future<void> initState() {
    _result.add("设备名称:${widget.device.info["name"]}");
    _result.add("设备型号:${widget.device.info["model"].replaceAll("#", ".")}");
    _result.add("物理地址:${widget.device.info["mac"]}");
    _result.add("id:${widget.device.info["id"]}");
    _result.add("固件作者:${widget.device.info["author"]}");
    _result.add("邮件:${widget.device.info["email"]}");
    _result.add("主页:${widget.device.info["home-page"]}");
    _result.add("固件程序:${widget.device.info["firmware-respository"]}");
    _result.add("固件版本:${widget.device.info["firmware-version"]}");
    _result.add("本网设备:${widget.device.isLocal ? "是" : "不是"}");
    _result.add("设备地址:${widget.device.ip}");
    _result.add("设备端口:${widget.device.port}");

    widget.device.info.forEach((key, value) {
      if (!_std_key.contains(key)) {
        _result.add("${key}:${value}");
      }
    });

    var tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    tilesList = tiles.toList();
    //判断这个网关是否已经被其他人添加
    _checkAddable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tilesList,
    ).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("网关"),
          actions: <Widget>[],
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

  //已经确认过可以添加，添加到我的账号
  _addToMyAccount() async {
    try {
      // 从服务器自动生成一个网关
      GatewayInfo gatewayInfo =
          await GatewayManager.GenerateOneGatewayWithDefaultServer();
      //使用网关信息将网关登录到服务器
      LoginResponse loginResponse =
          await GatewayLoginManager.LoginServerByToken(
              gatewayInfo.gatewayJwt, widget.device.ip, widget.device.port);
//    自动添加到我的列表
      if (loginResponse.loginStatus) {
        //将网关映射到本机
        _addToMySessionList(gatewayInfo.openIoTHubJwt, gatewayInfo.name).then((value) {
          if(Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          }
        });
      }
    } catch (exception) {
      Fluttertoast.showToast(msg: "登录失败：${exception}");
    }
  }

  //获取网关的登录状态判断是否可以被新用户添加
  Future _checkAddable() async {
    try {
      LoginResponse loginResponse =
          await GatewayLoginManager.CheckGatewayLoginStatus(
              widget.device.ip, widget.device.port);
      if (!loginResponse.loginStatus) {
        setState(() {
          tilesList.add(ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        _addToMyAccount();
                      },
                      child: Text("添加本网关到我的账号",style: TextStyle(color: Colors.green),))
                ]),
          ));
        });
      } else {
        setState(() {
          tilesList.add(ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("本网关已经被其他用户添加",style: TextStyle(color: Colors.red),)
                ]),
          ));
        });
      }
    } catch (exception) {
      Fluttertoast.showToast(msg: "获取网关的登录状态异常：$exception");
    }
  }
}
