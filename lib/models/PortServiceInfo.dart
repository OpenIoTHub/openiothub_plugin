class PortServiceInfo {
  String addr;
  int port;
  String? runId;
  String? realAddr;
  dynamic data;
  bool isLocal;
  Map<String, String>? info;
  PortServiceInfo(this.addr, this.port, this.isLocal, {this.runId, this.realAddr, this.data, this.info});
}