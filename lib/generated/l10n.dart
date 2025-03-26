// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OpenIoTHub`
  String get app_title {
    return Intl.message(
      'OpenIoTHub',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `RDP remote desktop`
  String get rdp_remote_desktop {
    return Intl.message(
      'RDP remote desktop',
      name: 'rdp_remote_desktop',
      desc: '',
      args: [],
    );
  }

  /// `选择本网关需要连接的服务器`
  String get select_server_for_gateway {
    return Intl.message(
      '选择本网关需要连接的服务器',
      name: 'select_server_for_gateway',
      desc: '',
      args: [],
    );
  }

  /// `添加网关成功！`
  String get add_gateway_success {
    return Intl.message(
      '添加网关成功！',
      name: 'add_gateway_success',
      desc: '',
      args: [],
    );
  }

  /// `登录失败！`
  String get login_failed {
    return Intl.message(
      '登录失败！',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `添加网关失败！`
  String get add_gateway_failed {
    return Intl.message(
      '添加网关失败！',
      name: 'add_gateway_failed',
      desc: '',
      args: [],
    );
  }

  /// `该网关已经被其他用户添加，请联系该网关管理员或者清空网关配置并重启网关`
  String get gateway_already_added {
    return Intl.message(
      '该网关已经被其他用户添加，请联系该网关管理员或者清空网关配置并重启网关',
      name: 'gateway_already_added',
      desc: '',
      args: [],
    );
  }

  /// `确认添加本网关到此服务器？`
  String get confirm_gateway_connect_this_server {
    return Intl.message(
      '确认添加本网关到此服务器？',
      name: 'confirm_gateway_connect_this_server',
      desc: '',
      args: [],
    );
  }

  /// `获取网关的登录状态异常`
  String get get_gateway_login_status_failed {
    return Intl.message(
      '获取网关的登录状态异常',
      name: 'get_gateway_login_status_failed',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `添加`
  String get add {
    return Intl.message(
      '添加',
      name: 'add',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
