// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_Hans locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_Hans';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "add_gateway_failed": MessageLookupByLibrary.simpleMessage("添加网关失败！"),
        "add_gateway_success": MessageLookupByLibrary.simpleMessage("添加网关成功！"),
        "app_title": MessageLookupByLibrary.simpleMessage("云亿连"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "confirm_gateway_connect_this_server":
            MessageLookupByLibrary.simpleMessage("确认添加本网关到此服务器？"),
        "gateway_already_added": MessageLookupByLibrary.simpleMessage(
            "该网关已经被其他用户添加，请联系该网关管理员或者清空网关配置并重启网关"),
        "get_gateway_login_status_failed":
            MessageLookupByLibrary.simpleMessage("获取网关的登录状态异常"),
        "login_failed": MessageLookupByLibrary.simpleMessage("登录失败！"),
        "select_server_for_gateway":
            MessageLookupByLibrary.simpleMessage("选择本网关需要连接的服务器")
      };
}
