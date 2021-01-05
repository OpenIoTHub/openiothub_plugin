import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_models/models/portService.dart';
import './components.dart';

//兼容的mdns类型，最终的落地点都在ModelsMap里
//没有的id和mac置空
class MDNS2ModelsMap {
  static final Map<String, String> baseInfo = {
    "name": "OpenIoTHub Entity",
    "model": WebPage.modelName,
    "mac": "",
    "id": "",
    "author": "Farry",
    "email": "newfarry@126.com",
    "home-page": "https://github.com/iotdevice",
    "firmware-respository": "https://github.com/iotdevice/*",
    "firmware-version": "version",
  };
  static final PortService basePortService = PortService(
      isLocal: true,
      info: {
        "name": "未知类型",
        "model": "",
        "mac": "",
        "id": "",
        "author": "Farry",
        "email": "newfarry@126.com",
        "home-page": "https://github.com/OpenIoTHub",
        "firmware-respository": "https://github.com/OpenIoTHub",
        "firmware-version": "version",
      },
      ip: "127.0.0.1",
      port: 80);
  //从ios14开始mdns发现的类型需要在Info.plist注册才可以被发现
  //	https://github.com/OpenIoTHub/OpenIoTHub/blob/41b1869951691a9084c66501b3d267daa4216577/ios/Runner/Info.plist#L38
  //请新模型的开发者同步在上述OpenIoTHub中的Info.plist添加新的mdns类型，如：_http._tcp
  //TODO：后续将会自动添加到Info.plist
      static

  Map<String, PortService> modelsMap = Map.from({
    //    OpenIoTHub网关模型
    Config.mdnsGatewayService: PortService(
        isLocal: true,
        info: {
          "name": "网关",
          "model": Gateway.modelName,
          "mac": "",
          "id": "",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub/gateway-go",
          "firmware-version": "version",
        },
        ip: "127.0.0.1",
        port: 80),
    //    web UI,http使用web方式打开服务的模型
    "_http._tcp": PortService(
        isLocal: true,
        info: {
          "name": "Http服务",
          "model": WebPage.modelName,
          "mac": "",
          "id": "",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub",
          "firmware-version": "version",
        },
        ip: "127.0.0.1",
        port: 80),
    //    web UI,http使用web方式打开服务的模型
    "_CGI._tcp": PortService(
        isLocal: true,
        info: {
          "name": "CGI Http服务",
          "model": WebPage.modelName,
          "mac": "",
          "id": "",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub",
          "firmware-version": "version",
        },
        ip: "127.0.0.1",
        port: 80),
    //    web UI,homeassistant使用web方式打开服务的模型
    "_home-assistant._tcp": PortService(
        isLocal: true,
        info: {
          "name": "HomeAssistant",
          "model": WebPage.modelName,
          "mac": "",
          "id": "",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://www.home-assistant.io",
          "firmware-respository":
          "https://github.com/home-assistant/home-assistant",
          "firmware-version": "version",
        },
        ip: "127.0.0.1",
        port: 80),
    //    vnc远程桌面模型
    "_rfb._tcp": PortService(
        isLocal: true,
        info: {
          "name": "VNC RFB远程桌面",
          "model": VNCWebPage.modelName,
          "mac": "",
          "id": "",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub/OpenIoTHub",
          "firmware-version": "version",
        },
        ip: "127.0.0.1",
        port: 80),
  });

  static List<String> getAllmDnsServiceType() {
    List<String> keys = [Config.mdnsIoTDeviceService];
    keys.addAll(modelsMap.keys.toList());
    return keys;
  }

  static List<String> getAllmDnsType() {
    List<String> keys = getAllmDnsServiceType();
    keys.addAll({Config.mdnsTypeExplorer});
    return keys;
  }
}
