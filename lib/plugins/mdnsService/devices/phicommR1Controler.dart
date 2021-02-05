//PhicommR1Controler:https://github.com/IoTDevice/phicomm-r1-controler
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/uploadOTA.dart';

class PhicommR1ControlerPage extends StatefulWidget {
  PhicommR1ControlerPage({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.phicomm-r1-controler";
  final PortService device;

  @override
  _PhicommR1ControlerPageState createState() => _PhicommR1ControlerPageState();
}

class _PhicommR1ControlerPageState extends State<PhicommR1ControlerPage> {
  static const int _up = 24;
  static const int _down = 25;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  color: Colors.green,
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
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  color: Colors.deepOrange,
                  iconSize: 100.0,
                  onPressed: () {
                    _Keyevent(_down);
                  },
                ),
              ],
            ),
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
}
