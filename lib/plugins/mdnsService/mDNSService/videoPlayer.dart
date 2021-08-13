import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key key, this.device}) : super(key: key);
  static final String modelName = "com.iotserv.services.vlc.player";
  final PortService device;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

VlcPlayerController _videoPlayerController;

class _VideoPlayerState extends State<VideoPlayer> {
  String url;

  @override
  void initState() {
    if (widget.device.info.containsKey("url")){
      url = widget.device.info["url"];
    } else if (!widget.device.info.containsKey("username") ||
        widget.device.info["username"] == "" ||
        widget.device.info["username"] == null) {
      url = "${widget.device.info["scheme"]}://" +
          "${widget.device.ip}:${widget.device.port}${widget.device.info["path"]}";
    } else {
      url = "${widget.device.info["scheme"]}://" +
          widget.device.info["username"] +
          ":" +
          widget.device.info["password"] +
          "@"
              "${widget.device.ip}:${widget.device.port}${widget.device.info["path"]}";
    }

    print("url:$url");
    _videoPlayerController = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    super.initState();
  }

  @override
  Future<void> dispose() {
    super.dispose();
    _videoPlayerController.stopRendererScanning();
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
      body: Center(
        child: VlcPlayer(
          controller: _videoPlayerController,
          aspectRatio: 16 / 9,
          placeholder: Center(child: CircularProgressIndicator()),
        ),
      ),
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
}
