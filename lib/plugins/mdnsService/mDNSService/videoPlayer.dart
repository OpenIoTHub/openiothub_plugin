import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key key, this.serviceInfo}) : super(key: key);
  static final String modelName = "com.iotserv.services.vlc.player";
  final PortService serviceInfo;
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}
VlcPlayerController controller ;
class _VideoPlayerState extends State<VideoPlayer> {
  String url ;
  @override
  void initState() {
    if (!widget.serviceInfo.info.containsKey("username") ||
        widget.serviceInfo.info["username"] == "" ||
        widget.serviceInfo.info["username"] == null) {
      url = "${widget.serviceInfo.info["scheme"]}://" +
    "${widget.serviceInfo.ip}:${widget.serviceInfo.port}${widget.serviceInfo.info["path"]}";
    } else {
      url = "${widget.serviceInfo.info["scheme"]}://" +
          widget.serviceInfo.info["username"] + ":" + widget.serviceInfo.info["password"] + "@"
    "${widget.serviceInfo.ip}:${widget.serviceInfo.port}${widget.serviceInfo.info["path"]}";
    }

    print("url:$url");
    controller = VlcPlayerController(onInit: (){controller.play();});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text(widget.serviceInfo.info["name"]),
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
          controller: controller,
          aspectRatio: 16/9,
          url:url ,
          placeholder: Center(child:CircularProgressIndicator()),

        ),
      ),);
  }
  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.serviceInfo,
          );
        },
      ),
    );
  }
}