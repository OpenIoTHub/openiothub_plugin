import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';

import './components.dart';

//TODO：为每一个模型添加图标信息
class ModelsMap {
  static Map<String, dynamic> modelsMap = Map.from({
    OneKeySwitchPage.modelName: (PortService device) {
//      简单的单按钮开关
      return OneKeySwitchPage(
        device: device,
      );
    },
//    斐讯DC1插排
    PhicommDC1PluginPage.modelName: (PortService device) {
      return PhicommDC1PluginPage(
        device: device,
      );
    },
    //    斐讯TC1插排
    PhicommTC1A1PluginPage.modelName: (PortService device) {
      return PhicommTC1A1PluginPage(
        device: device,
      );
    },
    //    斐讯TC1 A1   插排
    "com#iotserv#devices#phicomm_tc1_a1": (PortService device) {
      return PhicommTC1A1PluginPage(
        device: device,
      );
    },
//    DHT11,DTH22系列传感器
    DHTPage.modelName: (PortService device) {
      return DHTPage(
        device: device,
      );
    },
    //    光照强度传感器
    LightLevelPage.modelName: (PortService device) {
      return LightLevelPage(
        device: device,
      );
    },
    //    RGBA LED控制器
    RGBALedPage.modelName: (PortService device) {
      return RGBALedPage(
        device: device,
      );
    },
    //    串口315,433无线发射遥控器实现开门和关门
    Serial315433Page.modelName: (PortService device) {
      return Serial315433Page(
        device: device,
      );
    },
    //    斐讯R1音箱
    PhicommR1ControlerPage.modelName: (PortService device) {
      return PhicommR1ControlerPage(
        device: device,
      );
    },
    //    串口转TCP
    UART2TCPPage.modelName: (PortService device) {
      return UART2TCPPage(
        device: device,
      );
    },

    //
    //    web UI,使用web方式打开服务的模型
    WebPage.modelName: (PortService device) {
      return WebPage(
        device: device,
      );
    },
    //    https://github.com/qlwz/esp_dc1 暂时使用web方式打开
    "com.94qing.devices.esp_dc1": (PortService device) {
      return WebPage(
        device: device,
      );
    },
    //    webDAV文件
    // WebDAVPage.modelName: (PortService device) {
    //   return WebDAVPage(
    //     device: device,
    //   );
    // },
    //    gateway网关
    Gateway.modelName: (PortService device) {
      return Gateway(
        device: device,
      );
    },
    //    onvif摄像头管理工具
    OvifManagerPage.modelName: (PortService device) {
      return OvifManagerPage(
        device: device,
      );
    },
    //    VNC MacOS可测试
    VNCWebPage.modelName: (PortService device) {
      return VNCWebPage(
        device: device,
      );
    },
    VideoPlayer.modelName: (PortService device) {
      return VideoPlayer(
        device: device,
      );
    },
    MqttPhicommzDC1PluginPage.modelName: (PortService device) {
      return MqttPhicommzDC1PluginPage(
        device: device,
      );
    },
    MqttPhicommzTc1A1PluginPage.modelName: (PortService device) {
      return MqttPhicommzTc1A1PluginPage(
        device: device,
      );
    },
    MqttPhicommzA1PluginPage.modelName: (PortService device) {
      return MqttPhicommzA1PluginPage(
        device: device,
      );
    },
    MqttPhicommzM1PluginPage.modelName: (PortService device) {
      return MqttPhicommzM1PluginPage(
        device: device,
      );
    },
  });
}
