import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_plugin/generated/assets.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key, required this.baseUrl, required this.data});

  final String baseUrl;
  final Map<String, dynamic> data;

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  String _current_path = "/DATA";
  List<Map<String, String>> _side_paths = [
    {"name": "Root", "path": "/"},
    {"name": "DATA", "path": "/DATA"},
    {"name": "Documents", "path": "/DATA/Documents"},
    {"name": "Downloads", "path": "/DATA/Downloads"},
    {"name": "Gallery", "path": "/DATA/Gallery"},
    {"name": "Media", "path": "/DATA/Media"}
  ];
  Widget _files_list_widget = TDLoading(
    size: TDLoadingSize.small,
    icon: TDLoadingIcon.point,
    iconColor: Colors.grey,
  );
  var currentValue = 1;
  final _sideBarController = TDSideBarController();

  @override
  void initState() {
    setCurrentPathByValue(currentValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Files"),
        ),
        body: _buildPaginationSideBar(context));
  }

  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <SideItemProps>[];

    for (var i = 0; i < _side_paths.length; i++) {
      list.add(SideItemProps(
        index: i,
        label: _side_paths[i]["name"],
        value: i,
      ));
    }

    // list[1].badge = const TDBadge(TDBadgeType.redPoint);
    // list[2].badge = const TDBadge(
    //   TDBadgeType.message,
    //   count: '8',
    // );

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon,
                    textStyle: TextStyle(fontSize: 12)))
                .toList(),
            onSelected: setCurrentPathByValue,
          ),
        ),
        Expanded(
            child: SizedBox(
                height: demoHeight,
                child: SingleChildScrollView(
                  child: getPathFileList(),
                  physics: AlwaysScrollableScrollPhysics(),
                )))
      ],
    );
  }

  void setCurrentPathByValue(int value) {
    // 显示文件列表
    _current_path = _side_paths[value]["path"]!;
    displayImageList(_current_path);
  }

  // 文件夹内文件列表页面
  Widget getPathFileList() {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
              child: TDText('路径 $_current_path',
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            ),
            const SizedBox(height: 16),
            // displayImageList(path)
            _files_list_widget
          ],
        ));
  }

  // Widget getAnchorDemo(int index) {
  //   return Container(
  //     decoration: const BoxDecoration(color: Colors.white),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
  //           child: TDText('标题$index',
  //               style: const TextStyle(
  //                 fontSize: 14,
  //               )),
  //         ),
  //         const SizedBox(height: 16),
  //         displayImageList()
  //       ],
  //     ),
  //   );
  // }
  // 文件列表
  void displayImageList(String path) async {
    // TODO 根据api获取文件(夹)列表
    final dio = Dio(BaseOptions(baseUrl: widget.baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri = "/v1/folder";
    try {
      final response = await dio.get(reqUri, queryParameters: {"path": path});
      if (response.data["success"] == 200) {
        List<Widget> _row_list = [];
        // 一行
        List<Widget> _item_list = [];
        for (int i = 0; i < response.data["data"]["content"].length; i++) {
          if ((i + 1) % 3 == 0) {
            _item_list.add(displayImageItem(
                response.data["data"]["content"][i]["path"],
                response.data["data"]["content"][i]["name"],
                response.data["data"]["content"][i]["is_dir"],
                response.data["data"]["content"][i]));
            // 将所有行相加
            _row_list.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    _item_list.length, (index) => _item_list[index])));
            _item_list.clear();
            _row_list.add(
              const SizedBox(height: 18),
            );
          } else {
            _item_list.add(displayImageItem(
                response.data["data"]["content"][i]["path"],
                response.data["data"]["content"][i]["name"],
                response.data["data"]["content"][i]["is_dir"],
                response.data["data"]["content"][i]));
          }
        }
        ;
        setState(() {
          _files_list_widget = Column(
            children: _row_list,
          );
        });
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  // 文件(夹)图标
  Widget displayImageItem(
      String path, title, bool is_folder, Map<String, dynamic> content) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: Image.asset(
            is_folder ? Assets.casaFolder : Assets.casaFile,
            package: "openiothub_plugin",
            width: 48,
            height: 48,
            // 确保路径正确且已在pubspec.yaml中声明
          ),
          onTap: () {
            // TODO 如果pc则双击，如果移动端则单击
            if (is_folder) {
              _current_path = path;
              displayImageList(_current_path);
            } else {
              //TODO 下载或预览文件
            }
          },
        ),
        const SizedBox(height: 8),
        TDText(
          '$title',
          style: const TextStyle(fontSize: 12),
        )
      ],
    ));
  }
}

// {
// "success": 200,
// "message": "ok",
// "data": {
// "content": [
// {
// "name": "AppData",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-14T14:37:32.476952054+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/AppData",
// "date": "2025-04-14T14:37:32.476952054+08:00",
// "extensions": null
// },
// {
// "name": "Documents",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Documents",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// },
// {
// "name": "Downloads",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Downloads",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// },
// {
// "name": "Gallery",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Gallery",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// },
// {
// "name": "Media",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Media",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// }
// ],
// "total": 5,
// "index": 1,
// "size": 100000
// }
// }
