import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/aria2Native/Aria2Page.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/sshNative/SSHWebPage.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/vncWeb/VNCWebPage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenWithChoice extends StatelessWidget {
  PortConfig portConfig;

  static const String TAG_START = "startDivider";
  static const String TAG_END = "endDivider";
  static const String TAG_CENTER = "centerDivider";
  static const String TAG_BLANK = "blankDivider";

  static const double IMAGE_ICON_WIDTH = 30.0;

  final List listData = [];

  OpenWithChoice(this.portConfig) {
    listData.add(TAG_BLANK);
    listData.add(TAG_START);
    listData.add(
        ListItem(title: 'Web', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_CENTER);
    listData.add(
        ListItem(title: 'Aria2', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_CENTER);
    listData.add(
        ListItem(title: 'SSH', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_CENTER);
    listData.add(
        ListItem(title: 'VNC', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_CENTER);
    listData.add(ListItem(
        title: 'RDP远程桌面', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_END);
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  _renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      Widget w = Divider(
        height: 1.0,
      );
      switch (item) {
        case TAG_START:
          w = Divider(
            height: 1.0,
          );
          break;
        case TAG_END:
          w = Divider(
            height: 1.0,
          );
          break;
        case TAG_CENTER:
          w = Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: Divider(
              height: 1.0,
            ),
          );
          break;
        case TAG_BLANK:
          w = Container(
            height: 20.0,
          );
          break;
      }
      return w;
    } else if (item is ListItem) {
      var listItemContent = Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            getIconImage(item.icon),
            Expanded(
                child: Text(
              item.title,
              style: Constants.titleTextStyle,
            )),
            Constants.rightArrowIcon
          ],
        ),
      );
      return InkWell(
        onTap: () {
          String title = item.title;
          if (title == 'Aria2') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return Aria2NativePage(
                servicePort: portConfig.localProt,
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'SSH') {
            TextEditingController _username_controller =
                TextEditingController.fromValue(TextEditingValue(text: "root"));
            TextEditingController _password_controller =
                TextEditingController.fromValue(TextEditingValue(text: ""));
            showDialog(
                context: ctx,
                builder: (_) => AlertDialog(
                        title: Text("输入linux登录信息："),
                        content: ListView(
                          children: <Widget>[
                            TextFormField(
                              controller: _username_controller,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                labelText: '用户名',
                                helperText: 'linux用户名',
                              ),
                            ),
                            TextFormField(
                              controller: _password_controller,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                labelText: 'ssh密码',
                                helperText: '上述linux用户密码',
                              ),
                              obscureText: true,
                            )
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("取消"),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: Text("连接"),
                            onPressed: () {
                              Navigator.push(ctx,
                                  MaterialPageRoute(builder: (ctx) {
                                // return SSHWebPage(
                                return SSHNativePage(
                                  runId: portConfig.device.runId,
                                  remoteIp: portConfig.device.addr,
                                  remotePort: portConfig.remotePort,
                                  userName: _username_controller.text,
                                  passWord: _password_controller.text,
                                  localPort: portConfig.localProt,
                                  key: UniqueKey(),
                                );
                              })).then((_) {
                                Navigator.of(ctx).pop();
                              });
                            },
                          )
                        ])).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'VNC') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return VNCWebPage(
                runId: portConfig.device.runId,
                remoteIp: portConfig.device.addr,
                remotePort: portConfig.remotePort,
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'Web') {
            if (!Platform.isAndroid) {
              _launchURL("http://${Config.webgRpcIp}:${portConfig.localProt}");
              Navigator.of(ctx).pop();
            } else {
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
                    "http://${Config.webgRpcIp}:${portConfig.localProt}"));
              Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
                return Scaffold(
                  appBar: AppBar(title: Text("网页浏览器"), actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.open_in_browser,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          _launchURL(
                              "http://${Config.webgRpcIp}:${portConfig.localProt}");
                        })
                  ]),
                  body: WebViewWidget(controller: controller),
                );
              })).then((_) {
                Navigator.of(ctx).pop();
              });
            }
          } else if (title == 'RDP远程桌面') {
            var url =
                'rdp://full%20address=s:${Config.webgRpcIp}:${portConfig.localProt}&audiomode=i:2&disable%20themes=i:1';
            _launchURL(url).then((_) {
              Navigator.of(ctx).pop();
            });
          }
        },
        child: listItemContent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (ctx, i) => _renderRow(ctx, i),
        itemCount: listData.length,
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
