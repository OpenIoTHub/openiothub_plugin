import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/l10n/generated/openiothub_plugin_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './sub/appStore.dart';
import './sub/files.dart';
import './sub/settings.dart';
import './sub/terminal.dart';
import 'sub/systemInfo.dart';

class InstalledAppsPage extends StatefulWidget {
  const InstalledAppsPage(
      {super.key, required this.portService, required this.data});

  final PortService portService;
  final Map<String, dynamic> data;

  @override
  State<InstalledAppsPage> createState() => _InstalledAppsPageState();
}

class _InstalledAppsPageState extends State<InstalledAppsPage> {
  late List<ListTile> _listTiles = <ListTile>[];
  late List<ListTile> _versionListTiles = <ListTile>[];
  String? current_version;
  bool? need_update;
  String? change_log;

  @override
  void initState() {
    _initListTiles();
    _getVersionInfo();
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
                  TDIcons.chart,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SystemInfoPage(
                        key: UniqueKey(),
                        data: widget.data,
                        portService: widget.portService);
                  }));
                }),
            // 系统设置
            IconButton(
                icon: Icon(
                  TDIcons.setting,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SettingsPage(
                        key: UniqueKey(),
                        data: widget.data,
                        portService: widget.portService);
                  }));
                }),
            // 应用市场
            IconButton(
                icon: Icon(
                  TDIcons.app,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return AppStorePage(
                        key: UniqueKey(),
                        data: widget.data,
                        portService: widget.portService);
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
            // IconButton(
            //     icon: Icon(
            //       Icons.account_circle,
            //       // color: Colors.white,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            //         return UserInfoPage(
            //           key: UniqueKey(),
            //             data: widget.data,
            //             portService: widget.portService
            //         );
            //       }));
            //     }),
            // IconButton(
            //     icon: Icon(
            //       Icons.refresh,
            //       // color: Colors.white,
            //     ),
            //     onPressed: () {
            //       _initListTiles();
            //     })
            // 版本信息
            IconButton(
                icon: Icon(
                  Icons.info,
                  // color: Colors.white,
                ),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext buildContext,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return TDAlertDialog(
                        title: "Version Info",
                        content:
                            "current_version:${current_version}\nneed_update:${need_update}\nchange_log:${change_log}",
                      );
                    },
                  );
                }),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await _initListTiles();
              return;
            },
            child: ListView.separated(
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
            )));
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
  }

  Future<void> _getVersionInfo() async {
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v1/sys/version";
    final response = await dio.getUri(Uri.parse(reqUri));
    setState(() {
      current_version = response.data["data"]["current_version"];
      need_update = response.data["data"]["need_update"];
      change_log = response.data["data"]["version"]["change_log"];
    });
  }

  Future<void> _initListTiles() async {
    _listTiles.clear();
    //从API获取已安装应用列表
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/web/appgrid";
    final response = await dio.getUri(Uri.parse(reqUri));
    response.data["data"].forEach((appInfo) {
      // TODO 使用远程网络ID和远程端口临时映射远程端口到本机
      // TODO 获取当前服务映射到本机的端口号
      int localPort = 0;
      try {
        localPort = int.parse(appInfo["port"]);
      } catch (e) {
        print("appInfo[\"port\"]:${appInfo["port"]}");
        print(e);
      }

      setState(() {
        _listTiles.add(ListTile(
            //第一个功能项
            title: Text(appInfo["name"]),
            // subtitle: Text(appInfo["status"], style: TextStyle(),),
            subtitle: TDText(
              appInfo["status"],
              font: TDTheme.of(context).fontHeadlineSmall,
              textColor:
                  appInfo["status"] == "running" ? Colors.green : Colors.red,
              backgroundColor: appInfo["status"] == "running"
                  ? Colors.greenAccent
                  : Colors.orange,
            ),
            leading: _sizedContainer(
              CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                imageUrl: appInfo["icon"],
              ),
            ),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              TDActionSheet(context, visible: true, items: [
                TDActionSheetItem(
                  label: 'Start & Open Page',
                  icon: Icon(Icons.open_in_browser),
                ),
                TDActionSheetItem(
                  label: 'Upgrade',
                  icon: Icon(Icons.upgrade),
                ),
                TDActionSheetItem(
                  label: 'Remove',
                  icon: Icon(Icons.delete_forever),
                ),
                TDActionSheetItem(
                  label: 'Shutdown',
                  icon: Icon(
                    Icons.settings_power,
                    color: Colors.red,
                  ),
                ),
                TDActionSheetItem(
                  label: 'Reboot',
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.orange,
                  ),
                ),
              ], onSelected: (TDActionSheetItem item, int index) {
                switch (item.label) {
                  case 'Start & Open Page':
                    _startApp(appInfo["name"]);
                    _openWithWebBrowser(Config.webgRpcIp, localPort);
                    break;
                  case 'Upgrade':
                    _upgradeApp(appInfo["name"]);
                    break;
                  case 'Remove':
                    _removeApp(appInfo["name"], false);
                    break;
                  case 'Shutdown':
                    _changeAppStatus(appInfo["name"], "stop");
                    break;
                  case 'Reboot':
                    _changeAppStatus(appInfo["name"], "restart");
                    break;
                }
              });
            }));
      });
    });
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Center(child: child),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }

  _startApp(String appName) async {
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/compose/$appName}";
    final response = await dio.getUri(Uri.parse(reqUri));
  }

  _upgradeApp(String appName) async {
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/compose/$appName}";
    final response = await dio.patchUri(Uri.parse(reqUri));
  }

  _removeApp(String appName, bool? delete_config_folder) async {
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri =
        "/v2/app_management/compose/$appName?delete_config_folder=${delete_config_folder == null ? false : delete_config_folder}";
    final response = await dio.deleteUri(Uri.parse(reqUri));
  }

  _changeAppStatus(String appName, status) async {
    // status: restart,stop
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/compose/$appName/status";
    final response = await dio.putUri(Uri.parse(reqUri), data: status);
  }

  _openWithWebBrowser(String ip, int port) {
    if (!Platform.isAndroid) {
      // TODO
      _launchURL("http://$ip:$port");
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
        ..loadRequest(Uri.parse("http://$ip:$port"));
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
              title: Text(OpenIoTHubPluginLocalizations.of(ctx).web_browser),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.open_in_browser,
                      color: Colors.teal,
                    ),
                    onPressed: () {
                      _launchURL("http://$ip:$port");
                    })
              ]),
          body: WebViewWidget(controller: controller),
        );
      }));
    }
  }
}
