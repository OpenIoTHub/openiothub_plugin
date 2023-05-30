import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Aria2Page extends StatefulWidget {
  Aria2Page({required Key key, required this.localPort}) : super(key: key);
  int localPort;

  @override
  State<StatefulWidget> createState() => Aria2PageState();
}

class Aria2PageState extends State<Aria2Page> {
  @override
  Widget build(BuildContext context) {
    var initialUrl =
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/aria2/index.html";
    String jsCode =
        "window.localStorage.setItem(\'AriaNg.Options\', \'{\"language\":\"zh_Hans\",\"title\":\"\${downspeed}, \${upspeed} - \${title}\",\"titleRefreshInterval\":5000,\"browserNotification\":false,\"rpcAlias\":\"\",\"rpcHost\":\"localhost\",\"rpcPort\":\"${widget.localPort}\",\"rpcInterface\":\"jsonrpc\",\"protocol\":\"http\",\"httpMethod\":\"POST\",\"secret\":\"\",\"extendRpcServers\":[],\"globalStatRefreshInterval\":1000,\"downloadTaskRefreshInterval\":1000,\"rpcListDisplayOrder\":\"recentlyUsed\",\"afterCreatingNewTask\":\"task-list\",\"removeOldTaskAfterRetrying\":false,\"afterRetryingTask\":\"task-list-downloading\",\"displayOrder\":\"default:asc\",\"fileListDisplayOrder\":\"default:asc\",\"peerListDisplayOrder\":\"default:asc\"}\');location.reload();";

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
    controller.runJavaScript(jsCode);
    return WebViewWidget(controller: controller);
  }
}
