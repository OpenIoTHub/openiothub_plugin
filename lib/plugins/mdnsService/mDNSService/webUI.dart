//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  WebPage({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.web";
  final PortService device;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
//    解决退出没有断连的问题
    return Scaffold(
        appBar: AppBar(title: Text("网页浏览器"), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _info();
              }),
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                _launchURL(
                    "http://${widget.device.ip}:${widget.device.port}");
              })
        ]),
        body: Builder(builder: (BuildContext context) {
          return WebView(
              initialUrl:
                  "http://${widget.device.ip}:${widget.device.port}",
              javascriptMode: JavascriptMode.unrestricted);
        }));
  }

  _info() async {
    await Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      Navigator.of(context).pop();
      _launchURL('http://${widget.device.ip}:${widget.device.port}');
    } else {
      _launchURL('http://${widget.device.ip}:${widget.device.port}');
    }
  }

  _launchURL(String url) async {
//    await intent.launch();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
