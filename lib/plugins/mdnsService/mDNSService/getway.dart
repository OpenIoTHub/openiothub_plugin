import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gateway_grpc_api/pb/service.pb.dart';
import 'package:gateway_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_api/api/GateWay/GatewayLoginManager.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_api/utils/utils.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Gateway extends StatefulWidget {
  Gateway({Key key, this.serviceInfo}) : super(key: key);

  static final String modelName = "com.iotserv.services.gateway";
  final PortService serviceInfo;

  @override
  createState() => GatewayState();
}

class GatewayState extends State<Gateway> {
  static final String GATEWAY_CONFIG_KEY = "gateway_config";
  static Map<String, dynamic> gateway_config = {
    "ServerHost": "guonei.nat-cloud.com",
    "LoginKey": "HLLdsa544&*S",
    "ConnectionType": "tcp",
    "LastId": getOneUUID(),
    "TcpPort": "34320",
    "KcpPort": "34320",
    "UdpApiPort": "34321",
    "KcpApiPort": "34322",
    "TlsPort": "34321",
    "GrpcPort": "34322"
  };

  @override
  Future<void> initState() {
    super.initState();
    setState(() {
      _LastId_controller.text = widget.serviceInfo.info["id"];
    });
  }

//  string ServerHost = 1;
  TextEditingController _ServerHost_controller =
      TextEditingController.fromValue(
          TextEditingValue(text: gateway_config["ServerHost"].toString()));

//  string LoginKey = 2;
  TextEditingController _LoginKey_controller = TextEditingController.fromValue(
      TextEditingValue(text: gateway_config["LoginKey"].toString()));

//  string ConnectionType = 3;
  TextEditingController _ConnectionType_controller =
      TextEditingController.fromValue(
          TextEditingValue(text: gateway_config["ConnectionType"].toString()));

//  string LastId = 4;
  TextEditingController _LastId_controller = TextEditingController.fromValue(
      TextEditingValue(text: gateway_config["LastId"]));

//  int64 TcpPort = 5;
  TextEditingController _TcpPort_controller = TextEditingController.fromValue(
      TextEditingValue(text: gateway_config["TcpPort"].toString()));

//  int64 KcpPort = 6;
  TextEditingController _KcpPort_controller = TextEditingController.fromValue(
      TextEditingValue(text: gateway_config["KcpPort"].toString()));

//  int64 UdpApiPort = 7;
  TextEditingController _UdpApiPort_controller =
      TextEditingController.fromValue(
          TextEditingValue(text: gateway_config["UdpApiPort"].toString()));

//  int64 KcpApiPort = 8;
  TextEditingController _KcpApiPort_controller =
      TextEditingController.fromValue(
          TextEditingValue(text: gateway_config["KcpApiPort"].toString()));

//  int64 TlsPort = 9;
  TextEditingController _TlsPort_controller = TextEditingController.fromValue(
      TextEditingValue(text: gateway_config["TlsPort"].toString()));

//  int64 GrpcPort = 10;
  TextEditingController _GrpcPort_controller = TextEditingController.fromValue(
      TextEditingValue(text: gateway_config["GrpcPort"].toString()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("云易连(网关)"),
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
        body: ListView(
          children: <Widget>[
//        string ServerHost = 1;
            TextFormField(
              controller: _ServerHost_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器地址',
                helperText: 'ServerHost',
              ),
            ),
//        string LoginKey = 2;
            TextFormField(
              controller: _LoginKey_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器秘钥',
                helperText: 'LoginKey',
              ),
            ),
//        string ConnectionType = 3;
            TextFormField(
              controller: _ConnectionType_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入连接服务器的方式',
                helperText: 'ConnectionType',
              ),
            ),
//        string LastId = 4;
            TextFormField(
              controller: _LastId_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入本内网id',
                helperText: 'LastId',
              ),
            ),
//        int64 TcpPort = 5;
            TextFormField(
              controller: _TcpPort_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器TCP端口',
                helperText: 'TcpPort',
              ),
            ),
//        int64 KcpPort = 6;
            TextFormField(
              controller: _KcpPort_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器KCP端口',
                helperText: 'KcpPort',
              ),
            ),
//        int64 UdpApiPort = 7;
            TextFormField(
              controller: _UdpApiPort_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器UdpApiPort端口',
                helperText: 'UdpApiPort',
              ),
            ),
//        int64 KcpApiPort = 8;
            TextFormField(
              controller: _KcpApiPort_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器KcpApiPort端口',
                helperText: 'KcpApiPort',
              ),
            ),
//        int64 TlsPort = 9;
            TextFormField(
              controller: _TlsPort_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器TlsPort端口',
                helperText: 'TlsPort',
              ),
            ),
//        int64 GrpcPort = 10;
            TextFormField(
              controller: _GrpcPort_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器GrpcPort端口',
                helperText: 'GrpcPort',
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    child: Text("连接服务器"),
                    color: Colors.blue,
                    onPressed: () {
//                      从用户的填写中获取参数请求后端连接服务器
                      login();
                    },
                  ),
                  margin: EdgeInsets.all(10.0),
                ),
                RaisedButton(
                    child: Text("查看Token"),
                    color: Colors.green,
                    onPressed: () {
                      seeToken();
                    })
              ],
            )
          ],
        ));
  }

  login() async {
    try {
      ServerInfo serverInfo = ServerInfo();

      serverInfo.serverHost = _ServerHost_controller.text;
      serverInfo.loginKey = _LoginKey_controller.text;
      serverInfo.connectionType = _ConnectionType_controller.text;
      serverInfo.lastId = _LastId_controller.text;
      serverInfo.tcpPort = int.parse(_TcpPort_controller.text);
      serverInfo.kcpPort = int.parse(_KcpPort_controller.text);
      serverInfo.udpApiPort = int.parse(_UdpApiPort_controller.text);
      serverInfo.kcpApiPort = int.parse(_KcpApiPort_controller.text);
      serverInfo.tlsPort = int.parse(_TlsPort_controller.text);
      serverInfo.grpcPort = int.parse(_GrpcPort_controller.text);

      LoginResponse loginResponse =
          await GatewayLoginManager.LoginServerByServerInfo(
              serverInfo, widget.serviceInfo.ip, widget.serviceInfo.port);
//    自动添加到我的列表
      if (loginResponse.loginStatus) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                    title: Text("登录结果"),
                    content: Text("登录成功！现在可以获取访问Token来访问本内网了！"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("添加内网"),
                        onPressed: () {
                          addToMySessionList().then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    ]));
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                    title: Text("登录结果"),
                    content: Text("登录失败：${loginResponse.message}"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("确定"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]));
      }
    } catch (exception) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("登录服务器错误"),
                  content: Text(exception.toString()),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  seeToken() async {
    try {
      Token token = await GatewayLoginManager.GetOpenIoTHubToken(
          widget.serviceInfo.ip, widget.serviceInfo.port);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("本内网访问Token"),
                  content: TextFormField(initialValue: token.value),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("复制到剪切板"),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: token.value));
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取Token出现错误！"),
                  content: Text(e.toString()),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  Future addToMySessionList() async {
    Token token = await GatewayLoginManager.GetOpenIoTHubToken(
        widget.serviceInfo.ip, widget.serviceInfo.port);
    SessionConfig config = SessionConfig();
    config.token = token.value;
    config.description = '我的网络';
    createOneSession(config);
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      print('Greeter client received: ${response}');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.serviceInfo,
          );
        },
      ),
    );
  }
}
