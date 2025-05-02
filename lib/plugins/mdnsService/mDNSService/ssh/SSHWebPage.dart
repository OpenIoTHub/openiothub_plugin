import 'dart:async';
import 'dart:convert';

import 'package:dartssh2_plus/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import './virtual_keyboard.dart';
import 'package:xterm/xterm.dart';

class SSHNativePage extends StatefulWidget {
  SSHNativePage(
      {required Key key,
        required this.addr,
        required this.port,
        //   TODO 没有的话本页面请求用户名密码
        required this.userName,
        required this.passWord})
      : super(key: key);
  final String addr;
  final int port;
  final String userName;
  final String passWord;

  @override
  State<StatefulWidget> createState() => SSHNativePageState();
}

class SSHNativePageState extends State<SSHNativePage> {
  late final terminal = Terminal(inputHandler: keyboard);

  final keyboard = VirtualKeyboard(defaultInputHandler);

  var title = "";

  @override
  void initState() {
    super.initState();
    initTerminal();
  }

  Future<void> initTerminal() async {
    setState(() => this.title =
    "${widget.userName}@${widget.addr}:${widget.port}");
    terminal.write('Connecting...\r\n');

    final client = SSHClient(
      await SSHSocket.connect("localhost", widget.port),
      username: widget.userName,
      onPasswordRequest: () => widget.passWord,
    );

    terminal.write('Connected\r\n');

    final session = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);

    terminal.onTitleChange = (title) {
      setState(() => this.title = title);
    };

    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      session.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    terminal.onOutput = (data) {
      session.write(utf8.encode(data));
    };

    session.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    session.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        backgroundColor:
        CupertinoTheme.of(context).barBackgroundColor.withAlpha((255.0 * 0.5).round()),
      ),
      child: Column(
        children: [
          Expanded(
            child: TerminalView(terminal),
          ),
          VirtualKeyboardView(keyboard),
        ],
      ),
    );
  }
}
