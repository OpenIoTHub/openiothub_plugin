import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SSHWebPage extends StatefulWidget {
  SSHWebPage(
      {Key key,
      this.runId,
      this.remoteIp,
      this.remotePort,
      this.userName,
      this.passWord,
      this.localPort})
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
    return Scaffold(
      appBar: AppBar(
        title: Text("ssh"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: WebView(
        initialUrl:
            "http://${Config.webgRpcIp}:${Config.webStaticPort}/web/open/ssh/index.html",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          String jsCode =
              "window.localStorage.setItem(\'runId\', \'${widget.runId}\');window.localStorage.setItem(\'remoteIp\', \'${widget.remoteIp}\');window.localStorage.setItem(\'remotePort\', \'${widget.remotePort}\');window.localStorage.setItem(\'userName\', \'${widget.userName}\');window.localStorage.setItem(\'passWord\', \'${widget.passWord}\');location.reload();";
          webViewController.evaluateJavascript(jsCode);
        },
      ),
    );
  }
}
