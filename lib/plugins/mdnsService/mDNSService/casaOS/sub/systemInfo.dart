import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'widgets/indicator.dart';

class SystemInfoPage extends StatefulWidget {
  const SystemInfoPage(
      {super.key, required this.portService, required this.data});

  final PortService portService;
  final Map<String, dynamic> data;

  @override
  State<SystemInfoPage> createState() => _SystemInfoPageState();
}

class _SystemInfoPageState extends State<SystemInfoPage> {
  bool usb_auto_mount = true;
  Map<String, dynamic> utilization = {};
  int touchedIndex = -1;

  @override
  void initState() {
    getUtilization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = <Widget>[
      // CPU 饼状图
      AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.green,
                  text: 'Used CPU',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.grey,
                  text: 'Unused CPU',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
      // 内存 饼状图
      // 网络 折线图
      // 硬盘 饼状图
      // TODO USB
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("System Info"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: listView,
            ),
          ),
        ));
  }

  Future<void> getUtilization() async {
    final dio = Dio(BaseOptions(
        baseUrl: "http://${widget.portService.ip}:${widget.portService.port}",
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v1/sys/utilization";
    try {
      final response = await dio.putUri(Uri.parse(reqUri));
      if (response.data["success"] == 200) {
        setState(() {
          utilization = response.data["data"];
        });
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: utilization["cpu"]["percent"].toDouble(),
            title: '${utilization["cpu"]["percent"].toDouble()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.grey,
            value: (100 - utilization["cpu"]["percent"]).toDouble(),
            title: '${(100 - utilization["cpu"]["percent"]).toDouble()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
