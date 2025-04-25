import 'dart:io';

Future<String> get_ip_by_domain(String domain) async {
  String ip_str = "";
  try {
    // 使用 lookup 方法解析域名
    List<InternetAddress> addresses = await InternetAddress.lookup(domain);
    print('IP addresses for $domain:');
    addresses.forEach((address) {
      ip_str = address.address;
    });
  } catch (e) {
    print('Error looking up $domain: $e');
  }
  return ip_str;
}
