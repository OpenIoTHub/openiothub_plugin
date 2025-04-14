import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class AppStorePage extends StatefulWidget {
  const AppStorePage(
      {super.key, required this.portService, required this.data});

  final PortService portService;
  final Map<String, dynamic> data;

  @override
  State<AppStorePage> createState() => _AppStorePageState();
}

class _AppStorePageState extends State<AppStorePage> {
  late List<ListTile> _listTiles = <ListTile>[];

  @override
  void initState() {
    _initListTiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CasaOS/ZimaOS AppStore"),
          // actions: <Widget>[
          //   // 系统的各种状态
          //   IconButton(
          //       icon: Icon(
          //         TDIcons.chart,
          //         // color: Colors.white,
          //       ),
          //       onPressed: () {
          //
          //       }),
          // ],
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
        ));
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Center(child: child),
    );
  }

  Future<void> _initListTiles() async {
    _listTiles.clear();
    //从API获取已安装应用列表
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/apps";
    final response = await dio.getUri(Uri.parse(reqUri));
    response.data["data"]["list"].forEach((appName, appInfo) {
      // TODO 使用远程网络ID和远程端口临时映射远程端口到本机
      // TODO 获取当前服务映射到本机的端口号
      setState(() {
        _listTiles.add(ListTile(
            //第一个功能项
            title: Text(appName),
            subtitle: Text(appInfo["category"]),
            leading: _sizedContainer(
              CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                imageUrl: appInfo["icon"] == null
                    ? "http://${widget.portService.ip}:${widget.portService.port}/img/default.0a7cfbf2.svg"
                    : appInfo["icon"],
              ),
            ),
            // 根据有没有安装判断显示已安装按钮还是显示安装操作按钮
            trailing: response.data["data"]["installed"].contains(appName)
                ? TDButton(
                    text: 'Installed',
                    size: TDButtonSize.small,
                    type: TDButtonType.fill,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.light,
                    disabled: true,
                    onTap: () {
                      // TODO 安装
                    },
                  )
                : TDButton(
                    text: 'Install',
                    size: TDButtonSize.small,
                    type: TDButtonType.fill,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      // TODO 安装
                      _installApp(appName);
                    },
                  ),
            onTap: () {
              // TODO 判断有没有安装，没有就提示确认安装
            }));
      });
    });
  }

  _installApp(String appName) async {
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/apps/$appName/compose";
    final response = await dio.getUri(Uri.parse(reqUri));
  }
}
