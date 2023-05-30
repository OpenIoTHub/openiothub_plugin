import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SSHWebPage extends StatefulWidget {
  SSHWebPage(
      {required Key key,
      required this.runId,
      required this.remoteIp,
      required this.remotePort,
      required this.userName,
      required this.passWord,
      required this.localPort})
      : super(key: key);
  String runId;
  String remoteIp;
  int remotePort;
  String userName;
  String passWord;
  int localPort;

  @override
  State<StatefulWidget> createState() => SSHWebPageState();
}

class SSHWebPageState extends State<SSHWebPage> {
  // 标记是否是加载中
  @override
  Widget build(BuildContext context) {
    String jsCode =
        "window.localStorage.setItem(\'runId\', \'${widget.runId}\');window.localStorage.setItem(\'remoteIp\', \'${widget.remoteIp}\');window.localStorage.setItem(\'remotePort\', \'${widget.remotePort}\');window.localStorage.setItem(\'userName\', \'${widget.userName}\');window.localStorage.setItem(\'passWord\', \'${widget.passWord}\');location.reload();";
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
      ..loadRequest(Uri.parse(
          "http://${Config.webgRpcIp}:${Config.webStaticPort}/web/open/ssh/index.html"));
    controller.runJavaScript(jsCode);
    return Scaffold(
      appBar: AppBar(
        title: Text("ssh"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
