import 'package:get/get.dart';

class UserManager {
  var myIpAddress = "-".obs;
  var myName = "-".obs;
  var serverIpAddress = "-".obs;
  var isServer = false.obs;

  void updateMyIp(String ipAddress) {
    myIpAddress.value = ipAddress;
  }

  void updateMyName(String name) {
    myName.value = name;
  }

  void updateServerIpAddress(String ipAddress) {
    serverIpAddress.value = ipAddress;
  }

  void updateServer(bool isServer) {
    this.isServer.value = isServer;
  }

  void clearAllInformation() {
    myIpAddress.value = "-";
    myName.value = "-";
    serverIpAddress.value = "-";
    isServer.value = false;
  }
}