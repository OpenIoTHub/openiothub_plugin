import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNCWebPage extends StatefulWidget {
  VNCWebPage(
      {required Key key,
      required this.runId,
      required this.remoteIp,
      required this.remotePort})
      : super(key: key);
  String runId;
  String remoteIp;
  int remotePort;

  @override
  State<StatefulWidget> createState() => VNCWebPageState();
}

class VNCWebPageState extends State<VNCWebPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
          "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/vnc/index.html?host=${Config.webgRpcIp}&port=${Config.webRestfulPort}&path=proxy%2fws%2fconnect%2fwebsockify%3frunId%3d${widget.runId}%26remoteIp%3d${widget.remoteIp}%26remotePort%3d${widget.remotePort}&encrypt=0"));
    return Scaffold(
      key: _scaffoldKey,
      body: WebViewWidget(controller: controller),
    );
  }
}
