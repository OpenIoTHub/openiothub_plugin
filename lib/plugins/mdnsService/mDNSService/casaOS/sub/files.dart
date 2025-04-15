import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  var currentValue = 1;
  final _pageController = PageController(initialPage: 1);
  final _sideBarController = TDSideBarController();

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
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 110,
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
                icon: ele.icon))
                .toList(),
            onSelected: setCurrentValue,
          ),
        ),
        Expanded(
            child: SizedBox(
              height: demoHeight,
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: pages,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ))
      ],
    );
  }

  Widget getPageDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: TDText('标题$index',
                style: const TextStyle(
                  fontSize: 14,
                )),
          ),
          const SizedBox(height: 16),
          displayImageList()
        ],
      ),
    );
  }

  Widget getAnchorDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: TDText('标题$index',
                style: const TextStyle(
                  fontSize: 14,
                )),
          ),
          const SizedBox(height: 16),
          displayImageList()
        ],
      ),
    );
  }

  Widget displayImageList() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          displayImageItem('标题文字'),
          displayImageItem('标题文字'),
          displayImageItem('最多六个文字'),
        ]),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            displayImageItem('标题文字'),
            displayImageItem('标题文字'),
            displayImageItem('最多六个文字'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            displayImageItem('标题文字'),
            displayImageItem('标题文字'),
            displayImageItem('最多六个文字'),
          ],
        )
      ],
    );
  }

  Widget displayImageItem(String title) {
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/plugins/casa/folder.png',
              package: "openiothub_plugin",
              width: 48,
              height: 48,
              // 确保路径正确且已在pubspec.yaml中声明
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
