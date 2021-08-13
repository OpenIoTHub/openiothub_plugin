import 'dart:convert';

import 'package:http/http.dart' as http;

main() async {
  String url =
      "http://127.0.0.1:54887/list";
  http.Response response;
  try {
    response = await http.get(url).timeout(const Duration(seconds: 2));
    print(response.body);
    Map<String, dynamic> rst = jsonDecode(response.body);
    if (rst["Code"] != 0) {
      print("rst[\"Code\"] != 0");
      return;
    }
    print(rst["OnvifDevices"]);
    List<dynamic> l = rst["OnvifDevices"];
    for (dynamic value in l) {
      print(value);
      print(value["Name"]);
    }
  } catch (e) {
    print(e.toString());
    return;
  }
}