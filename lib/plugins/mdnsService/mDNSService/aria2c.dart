
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Aria2Page extends StatefulWidget {
  Aria2Page({Key key, this.serviceInfo}) : super(key: key);
  static final String modelName = "com.iotserv.services.aria2c";
  final PortService serviceInfo;

  @override
  State<StatefulWidget> createState() => Aria2PageState();
}

class Aria2PageState extends State<Aria2Page> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:
          "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/aria2/index.html",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        String jsCode =
            "window.localStorage.setItem(\'AriaNg.Options\', \'{\"language\":\"zh_Hans\",\"title\":\"\${downspeed}, \${upspeed} - \${title}\",\"titleRefreshInterval\":5000,\"browserNotification\":false,\"rpcAlias\":\"\",\"rpcHost\":\"${widget.serviceInfo.ip}\",\"rpcPort\":\"${widget.serviceInfo.port}\",\"rpcInterface\":\"jsonrpc\",\"protocol\":\"http\",\"httpMethod\":\"POST\",\"secret\":\"\",\"extendRpcServers\":[],\"globalStatRefreshInterval\":1000,\"downloadTaskRefreshInterval\":1000,\"rpcListDisplayOrder\":\"recentlyUsed\",\"afterCreatingNewTask\":\"task-list\",\"removeOldTaskAfterRetrying\":false,\"afterRetryingTask\":\"task-list-downloading\",\"displayOrder\":\"default:asc\",\"fileListDisplayOrder\":\"default:asc\",\"peerListDisplayOrder\":\"default:asc\"}\');location.reload();";
        webViewController.evaluateJavascript(jsCode);
      },
    );
  }
}
