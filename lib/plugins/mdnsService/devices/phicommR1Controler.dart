//PhicommR1Controler:https://github.com/IoTDevice/phicomm-r1-controler
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';

class PhicommR1ControlerPage extends StatefulWidget {
  PhicommR1ControlerPage({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.phicomm-r1-controler";
  final PortService device;

  @override
  _PhicommR1ControlerPageState createState() => _PhicommR1ControlerPageState();
}

class _PhicommR1ControlerPageState extends State<PhicommR1ControlerPage> {
  static const int _up = 24;
  static const int _off = 164;
  static const int _down = 25;
  int _currentKey = 1;
  TextEditingController _cmd_controller =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  static const Map<int, String> keyevents = {
    1: "按键 Soft Left",
    2: "按键 Soft Right",
    3: "按键 Home",
    4: "返回键",
    5: "拨号键",
    6: "挂机键",
    7: "按键0",
    8: "按键1",
    9: "按键2",
    10: "按键3",
    11: "按键4",
    12: "按键5",
    13: "按键6",
    14: "按键7",
    15: "按键8",
    16: "按键9",
    17: "按键*",
    18: "按键#",
    19: "导航键向上",
    20: "导航键向下",
    21: "导航键向左",
    22: "导航键向右",
    23: "导航键确定键",
    24: "音量增加键",
    25: "音量减小键",
    26: "电源键",
    27: "拍照键",
    28: "按键 Clear",
    29: "按键 A",
    30: "按键 B",
    31: "按键 C",
    32: "按键 D",
    33: "按键 E",
    34: "按键 F",
    35: "按键 G",
    36: "按键 H",
    37: "按键 I",
    38: "按键 J",
    39: "按键 K",
    40: "按键 L",
    41: "按键 M",
    42: "按键 N",
    43: "按键 O",
    44: "按键 P",
    45: "按键 Q",
    46: "按键 R",
    47: "按键 S",
    48: "按键 T",
    49: "按键 U",
    50: "按键 V",
    51: "按键 W",
    52: "按键 X",
    53: "按键 Y",
    54: "按键 Z",
    55: "按键 ,",
    56: "按键 .",
    57: "Alt + Left",
    58: "Alt + Right",
    59: "Shift + Left",
    60: "Shift + Right",
    61: "Tab 键",
    62: "空格键",
    63: "按键 Symbol modifier",
    64: "按键 Explorer special function",
    65: "按键 Envelope special function",
    66: "回车键",
    67: "退格键",
    68: "按键 `",
    69: "按键 -",
    70: "按键 =",
    71: "按键 [",
    72: "按键 ]",
    73: "按键 \\",
    74: "按键 ;",
    75: "按键单引号",
    76: "按键 /",
    77: "按键 @",
    78: "按键 Number modifier",
    79: "按键 Headset Hook",
    80: "拍照 对焦键",
    81: "按键 +",
    82: "菜单键",
    83: "通知键",
    84: "搜索键",
    85: "",
    86: "多媒体键 停止",
    87: "多媒体键 下一首",
    88: "多媒体键 上一首",
    89: "多媒体键 快退",
    90: "多媒体键 快进",
    91: "话筒静音键",
    92: "向上翻页键",
    93: "向下翻页键",
    94: "按键 Picture Symbols modifier",
    95: "按键 Switch Charset modifier",
    96: "游戏手柄按钮 A",
    97: "游戏手柄按钮 B",
    98: "游戏手柄按钮 C",
    99: "游戏手柄按钮 X",
    100: "游戏手柄按钮 Y",
    101: "游戏手柄按钮 Z",
    102: "游戏手柄按钮 L1",
    103: "游戏手柄按钮 R1",
    104: "游戏手柄按钮 L2",
    105: "游戏手柄按钮 R2",
    106: "Left Thumb Button",
    107: "Right Thumb Button",
    108: "游戏手柄按钮 Start",
    109: "游戏手柄按钮 Select",
    110: "游戏手柄按钮 Mode",
    111: "ESC 键",
    112: "删除键",
    113: "Control + Left",
    114: "Control + Right",
    115: "大写锁定键",
    116: "滚动锁定键",
    117: "按键 Left Meta modifier",
    118: "按键 Right Meta modifier",
    119: "按键 Function modifier",
    120: "按键 System Request / Print Screen",
    121: "Break/Pause键",
    122: "光标移动到开始键",
    123: "光标移动到末尾键",
    124: "插入键",
    125: "按键 Forward",
    126: "多媒体键 播放",
    127: "多媒体键 暂停",
    128: "多媒体键 关闭",
    129: "多媒体键 弹出",
    130: "多媒体键 录音",
    131: "按键 F1",
    132: "按键 F2",
    133: "按键 F3",
    134: "按键 F4",
    135: "按键 F5",
    136: "按键 F6",
    137: "按键 F7",
    138: "按键 F8",
    139: "按键 F9",
    140: "按键 F10",
    141: "按键 F11",
    142: "按键 F12",
    143: "小键盘锁",
    144: "小键盘按键0",
    145: "小键盘按键1",
    146: "小键盘按键2",
    147: "小键盘按键3",
    148: "小键盘按键4",
    149: "小键盘按键5",
    150: "小键盘按键6",
    151: "小键盘按键7",
    152: "小键盘按键8",
    153: "小键盘按键9",
    154: "小键盘按键/",
    155: "小键盘按键*",
    156: "小键盘按键-",
    157: "小键盘按键+",
    158: "小键盘按键.",
    159: "小键盘按键,",
    160: "小键盘按键回车",
    161: "小键盘按键=",
    162: "小键盘按键(",
    163: "小键盘按键)",
    164: "扬声器静音键",
    165: "按键 Info",
    166: "按键 Channel up",
    167: "按键 Channel down",
    168: "放大键",
    169: "缩小键",
    170: "按键 TV",
    171: "按键 Window",
    172: "按键 Guide",
    173: "按键 DVR",
    174: "按键 Bookmark",
    175: "按键 Toggle captions",
    176: "按键 Settings",
    177: "按键 TV power",
    178: "按键 TV input",
    179: "按键 Set-top-box power",
    180: "按键 Set-top-box input",
    181: "按键 A/V Receiver power",
    182: "按键 A/V Receiver input",
    183: "按键 Red “programmable",
    184: "按键 Green “programmable",
  };

  @override
  void initState() {
    super.initState();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info["name"]),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("音量控制:"),
                IconButton(
                  icon: Icon(Icons.volume_down),
                  color: Colors.cyan,
                  iconSize: 100.0,
                  onPressed: () {
                    _Keyevent(_down);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_off),
                  color: Colors.red,
                  iconSize: 100.0,
                  onPressed: () {
                    _Keyevent(_off);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  color: Colors.orange,
                  iconSize: 100.0,
                  onPressed: () {
                    _Keyevent(_up);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("查看屏幕截图"),
                  onPressed: () {
                    _showImage();
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _cmd_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '请输入需要在安卓上执行的命令',
                    helperText: 'shell cmd',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("开始执行上述命令"),
                  onPressed: () {
                    _doCmd(_cmd_controller.text);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("输入按键:"),
                DropdownButton<int>(
                  value: _currentKey,
                  onChanged: _Keyevent,
                  items: _getModesList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("安装apk程序"),
                  onPressed: () {
                    _installApk();
                  },
                )
              ],
            ),
          //TODO  原厂配网和非原厂配网
          ]),
    );
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
          );
        },
      ),
    );
  }

  _Keyevent(int key) async {
    setState(() {
      _currentKey = key;
    });
    String url =
        "http://${widget.device.ip}:${widget.device.port}/input-keyevent?key=$key";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _showImage() async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("屏幕截图:"),
                content: Image.network(
                    "http://${widget.device.ip}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}"),
                actions: <Widget>[
                  TextButton(
                    child: Text("确认"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  _doCmd(String cmd) async {
    String url =
        "http://${widget.device.ip}:${widget.device.port}/do-cmd?cmd=$cmd";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      Fluttertoast.showToast(msg: response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _installApk() async {
    var dio = Dio();
    Directory rootPath = await getExternalStorageDirectory();
    String path = await FilesystemPicker.open(
      title: '选择安卓apk程序',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.all,
      folderIconColor: Colors.teal,
      // allowedExtensions: ['.apk'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if(path == null) {
      Fluttertoast.showToast(msg: "User canceled the picker");
      return;
    }
    Fluttertoast.showToast(msg: rootPath.path);
    String url =
        "http://${widget.device.ip}:${widget.device.port}/install-apk";
    Response response;
    try {
      //安装apk
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path,filename: "android.apk"),
      });
      response = await dio.post(url, data: formData);
      Fluttertoast.showToast(msg: response.toString());
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  List<DropdownMenuItem<int>> _getModesList() {
    List<DropdownMenuItem<int>> l = [];
    keyevents.forEach((int k, String v) {
      l.add(DropdownMenuItem<int>(
        value: k,
        child: Text(v),
      ));
    });
    return l;
  }
}
