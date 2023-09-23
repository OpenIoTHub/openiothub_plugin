//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../mdnsService/commWidgets/info.dart';

class WebPage extends StatefulWidget {
  WebPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.web";
  final PortService device;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
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
      ..loadRequest(
          Uri.parse("http://${widget.device.ip}:${widget.device.port}"));
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
                _launchURL("http://${widget.device.ip}:${widget.device.port}");
              })
        ]),
        body: Builder(builder: (BuildContext context) {
          return WebViewWidget(controller: controller);
        }));
  }

  _info() async {
    Navigator.of(context).pop();
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   Navigator.of(context).pop();
    //   _launchURL('http://${widget.device.ip}:${widget.device.port}');
    // } else {
    //   _launchURL('http://${widget.device.ip}:${widget.device.port}');
    // }
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
