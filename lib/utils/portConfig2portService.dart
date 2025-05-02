import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

PortService portConfig2portService(PortConfig portConfig) {
  portConfig.mDNSInfo.info.addAll({"runId":portConfig.device.runId, "remoteAddr":portConfig.device.addr});
  var portService = PortService(
    // 设备的实际地址
    ip: Config.webgRpcIp,
    port: portConfig.localProt,
    // 如果不是本网设备（是远程设备）则 使用的ip为127.0.0.1
    isLocal: false,
    // TODO 能不能直接使用mDNSInfo
    info: portConfig.mDNSInfo.info,
  );
  return portService;
}