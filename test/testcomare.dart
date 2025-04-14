import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

var list = <Item>[
  Item(title: "a", isTopping: true),
  Item(title: "b"),
  Item(title: "d"),
  Item(title: "c", isTopping: true),
];

main() async {
  /// 通过排序把顶置的信息放在前面
  list.sort((a, b) => b.title.compareTo(a.title));
  for (var item in list) {
    print(item.title); // 1324
  }
}

class Item {
  Item({
    this.title = '',
    this.isTopping = false,
  });
  String title;
  bool isTopping;
  int get top => isTopping ? 1 : 0;
}
