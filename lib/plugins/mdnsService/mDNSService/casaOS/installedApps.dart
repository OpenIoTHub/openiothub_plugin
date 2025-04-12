import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../l10n/generated/openiothub_plugin_localizations.dart';
import './sub/appStore.dart';
import './sub/files.dart';
import './sub/settings.dart';
import './sub/systemInfo.dart';
import './sub/terminal.dart';
import './sub/userInfo.dart';

class InstalledAppsPage extends StatefulWidget {
  const InstalledAppsPage({super.key, required this.data});

  final Map<String, Map<String, dynamic>> data;

  @override
  State<InstalledAppsPage> createState() => _InstalledAppsPageState();
}

class _InstalledAppsPageState extends State<InstalledAppsPage> {
  late List<ListTile> _listTiles  = <ListTile>[];
  @override
  void initState() {
    _initListTiles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CasaOS/ZimaOS Dashboard"),
          actions: <Widget>[
            // 系统的各种状态
            IconButton(
                icon: Icon(
                  Icons.cloud,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SystemInfoPage(
                      key: UniqueKey(),
                    );
                  }));
                }),
            // 系统设置
            IconButton(
                icon: Icon(
                  Icons.settings,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SettingsPage(
                      key: UniqueKey(),
                    );
                  }));
                }),
            // 应用市场
            IconButton(
                icon: Icon(
                  Icons.store,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return AppStorePage(
                      key: UniqueKey(),
                    );
                  }));
                }),
            // 文件管理
            IconButton(
                icon: Icon(
                  Icons.file_copy_outlined,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return FileManagerPage(
                      key: UniqueKey(),
                    );
                  }));
                }),
            // 终端
            IconButton(
                icon: Icon(
                  Icons.terminal,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return TerminalPage(
                      key: UniqueKey(),
                    );
                  }));
                }),
            // 当前用户信息
            IconButton(
                icon: Icon(
                  Icons.account_circle,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return UserInfoPage(
                      key: UniqueKey(),
                    );
                  }));
                })
          ],
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            return _buildListTile(index);
          },
          separatorBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(left: 50), // 添加左侧缩进
              child: TDDivider(),
            );
          },
          itemCount: _listTiles.length,
        )
    );
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
  }

  _initListTiles() {
    setState(() {
      _listTiles.clear();
      //TODO 从API获取已安装应用列表
      _listTiles.add(
        ListTile(
          //第一个功能项
            title: Text("App Name"),
            leading: Icon(TDIcons.setting, color: Colors.red),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              if (!Platform.isAndroid) {
                // TODO
                _launchURL("http://${Config.webgRpcIp}:123");
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
                      "http://${Config.webgRpcIp}:123"));
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return Scaffold(
                    appBar: AppBar(title: Text(OpenIoTHubPluginLocalizations.of(ctx).web_browser), actions: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.open_in_browser,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            _launchURL(
                                "http://${Config.webgRpcIp}:123");
                          })
                    ]),
                    body: WebViewWidget(controller: controller),
                  );
                }));
              }
            })
      );
    });
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }
}
