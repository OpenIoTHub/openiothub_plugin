

import 'package:openiothub_plugin/utils/ip.dart';

main() async {
    var hostname = "esp-switch-80:7D:3A:72:64:6F.local";
    print(hostname.endsWith(".local"));
    var ip = await get_ip_by_domain(hostname);
    print(ip);
    // var uri = Uri(
    //     scheme: 'http',
    //     host: "esp-switch-80:7D:3A:72:64:6F.local",
    //     port: 80,
    //     path: '/switch',
    //     queryParameters: {
    // });
    // print(uri.toString());
    var input = 'var csrf_token = "E5FDD8E7277F5CC6";';
    RegExp regExp = RegExp(r'var csrf_token = "(.*?)";'); // 使用非贪婪匹配来获取双引号内的内容
    Match? match = regExp.firstMatch(input);
    if (match != null) {
        String token = match.group(1)!; // group(1) 是捕获组的内容
        print(token); // 输出: E5FDD8E7277F5CC6
    }
}
