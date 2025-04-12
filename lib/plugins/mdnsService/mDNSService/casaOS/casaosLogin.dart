//这个模型是用来局域网或者远程操作casaOS的
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';

import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/plugins/mdnsService/mDNSService/casaOS/installedApps.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

//手动注册一些端口到mdns的声明，用于接入一些传统的设备或者服务或者帮助一些不方便注册mdns的设备或服务注册
//需要选择模型和输入相关配置参数
class CasaOSLoginPage extends StatefulWidget {
  CasaOSLoginPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.zimaspace.casaos.webpage.v1";
  final PortService device;

  @override
  _CasaOSLoginPageState createState() => _CasaOSLoginPageState();
}

class _CasaOSLoginPageState extends State<CasaOSLoginPage> {
  OpenIoTHubPluginLocalizations? localizations;
  List<Widget> _list = <Widget>[];

  final TextEditingController _username = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initList();
    return Scaffold(
        appBar: AppBar(
          title: Text("CasaOS/ZimaOS Login"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _list,
            ),
          ),
        ));
  }

  Future<void> _initList() async {
    setState(() {
      _list = <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: TDInput(
            controller: _username,
            backgroundColor: Colors.white,
            leftLabel: OpenIoTHubPluginLocalizations
                .of(context)
                .username,
            hintText: OpenIoTHubPluginLocalizations
                .of(context)
                .please_input_user_name,
            onChanged: (String v) {},
          ),
        ),
        TDInput(
          controller: _userpassword,
          backgroundColor: Colors.white,
          leftLabel: OpenIoTHubPluginLocalizations
              .of(context)
              .password,
          hintText: OpenIoTHubPluginLocalizations
              .of(context)
              .please_input_password,
          obscureText: true,
          onChanged: (String v) {},
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDButton(
                  icon: TDIcons.login,
                  text: OpenIoTHubPluginLocalizations
                      .of(context)
                      .login,
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.primary,
                  onTap: () async {
                    if (_username.text.isEmpty ||
                        _userpassword.text.isEmpty) {
                      showToast(OpenIoTHubPluginLocalizations
                          .of(context)
                          .username_and_password_cant_be_empty);
                      return;
                    }
                    // 登录并跳转
                    login_and_goto_dashboard(
                        _username.text, _userpassword.text);
                  })
            ],
          ),
        )
      ];
    });
  }

  Future<void> login_and_goto_dashboard(String username, password) async {
    final dio = Dio();
    late String url;
    String reqUrl =
        "http://192.168.124.33/v1/users/login";
    try {
      final response = await dio.post(
          reqUrl, data: {username: username, password: password});
      if (response.data["success"] == 200) {
        //  登录成功
        Map<String, Map<String, dynamic>> data = response.data["data"];
        // 跳转到已安装应用页面
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return InstalledAppsPage(
            key: UniqueKey(),
            data: data,
          );
        }));
        return;
      } else {
        //  登录失败
        showToast("Login failed");
      }
    } catch (e) {
      //  登录失败
      showToast(e.toString());
      print(e.toString());
      return;
    }
    // {
    //     "success": 200,
    //     "message": "ok",
    //     "data": {
    //         "token": {
    //             "refresh_token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImZhcnJ5IiwiaWQiOjEsImlzcyI6InJlZnJlc2giLCJleHAiOjE3NDQ5ODMxMjEsIm5iZiI6MTc0NDM3ODMyMSwiaWF0IjoxNzQ0Mzc4MzIxfQ.wEkjHW9MiW5uTc6FWm7dD_fnELH-lH4rQeCvg7Y23yyxDw0Q4lpkjPe1RrLeyvUtTgJGV28Fs6gJdVawkdgxyg",
    //             "access_token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImZhcnJ5IiwiaWQiOjEsImlzcyI6ImNhc2FvcyIsImV4cCI6MTc0NDM4OTEyMSwibmJmIjoxNzQ0Mzc4MzIxLCJpYXQiOjE3NDQzNzgzMjF9.xaAjvSdvv4LURGfKiieGiyLS_o5AACQLTFmyQnF18M0HvzsluWuEDXLPcktfer_lUkWlCh_uaxc6wjs_FmP3mA",
    //             "expires_at": 1744389121
    //         },
    //         "user": {
    //             "id": 1,
    //             "username": "farry",
    //             "role": "admin",
    //             "email": "",
    //             "nickname": "",
    //             "avatar": "",
    //             "description": "",
    //             "created_at": "2025-04-07T15:46:11.072390204+08:00",
    //             "updated_at": "0001-01-01T00:00:00Z"
    //         }
    //     }
    // }
  }
}
