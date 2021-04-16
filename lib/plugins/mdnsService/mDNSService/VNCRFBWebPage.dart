import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNCWebPage extends StatefulWidget {
  VNCWebPage({Key key, this.serviceInfo}) : super(key: key);

  static final String modelName = "com.iotserv.services.vnc";
  final PortService serviceInfo;

  @override
  State<StatefulWidget> createState() => VNCWebPageState();
}

class VNCWebPageState extends State<VNCWebPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var url =
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/vnc/index.html?host=${Config.webgRpcIp}&port=${Config.webRestfulPort}&path=proxy%2fws%2fconnect%2fwebsockify%3fip%3d${widget.serviceInfo.ip}%26port%3d${widget.serviceInfo.port}&encrypt=0";
    _launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    var url =
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/vnc/index.html?host=${Config.webgRpcIp}&port=${Config.webRestfulPort}&path=proxy%2fws%2fconnect%2fwebsockify%3fip%3d${widget.serviceInfo.ip}%26port%3d${widget.serviceInfo.port}&encrypt=0";
    return Scaffold(
      key: _scaffoldKey,
      body:
          WebView(initialUrl: url, javascriptMode: JavascriptMode.unrestricted),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
