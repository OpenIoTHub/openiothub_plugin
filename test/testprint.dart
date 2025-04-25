

import 'package:openiothub_plugin/utils/ip.dart';

main() async {
    var ip = await get_ip_by_domain("esp-switch-80:7D:3A:72:64:6F.local");
    print(ip);
    // var uri = Uri(
    //     scheme: 'http',
    //     host: "esp-switch-80:7D:3A:72:64:6F.local",
    //     port: 80,
    //     path: '/switch',
    //     queryParameters: {
    // });
    // print(uri.toString());
}
