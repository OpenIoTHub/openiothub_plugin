import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key key, this.portService}) : super(key: key);
  PortService portService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
    final List _result = [];
    _result.add("设备名称:${portService.info["name"]}");
    _result.add("设备型号:${portService.info["model"].replaceAll("#", ".")}");
    _result.add("物理地址:${portService.info["mac"]}");
    _result.add("id:${portService.info["id"]}");
    _result.add("固件作者:${portService.info["author"]}");
    _result.add("邮件:${portService.info["email"]}");
    _result.add("主页:${portService.info["home-page"]}");
    _result.add("固件程序:${portService.info["firmware-respository"]}");
    _result.add("固件版本:${portService.info["firmware-version"]}");
    _result.add("本网设备:${portService.isLocal ? "是" : "不是"}");
    _result.add("设备地址:http://${portService.ip}:${portService.port}");

    portService.info.forEach((key, value) {
      if (!_std_key.contains(key)) {
        _result.add("${key}:${value}");
      }
    });

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
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                TextEditingController _new_name_controller =
                    TextEditingController.fromValue(
                        TextEditingValue(text: portService.info["name"]));
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: Text("修改名称："),
                            content: ListView(
                              children: <Widget>[
                                TextFormField(
                                  controller: _new_name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: '请输入新的名称',
                                    helperText: '名称',
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("取消"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("修改"),
                                onPressed: () async {
                                  await rename(portService.info["id"],
                                      _new_name_controller.text);
                                  Navigator.of(context).pop();
                                },
                              )
                            ])).then((restlt) {
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  rename(String id, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> device_cname_map = Map<String, dynamic>();
    if (prefs.containsKey(SharedPreferencesKey.DEVICE_CNAME_KEY)) {
      String device_cname = await prefs.getString(SharedPreferencesKey.DEVICE_CNAME_KEY);
      device_cname_map = jsonDecode(device_cname);
      device_cname_map[id] = name;
    } else {
      device_cname_map[id] = name;
    }
    await prefs.setString(
        SharedPreferencesKey.DEVICE_CNAME_KEY, jsonEncode(device_cname_map));
  }
}
