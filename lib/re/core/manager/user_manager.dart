import 'package:get/get.dart';

class UserManager {
  var myIpAddress = "-".obs;
  var myName = "-".obs;
  var serverIpAddress = "-".obs;
  var isBoss = false.obs;

  void updateMyIp(String ipAddress) {
    myIpAddress.value = ipAddress;
  }

  void updateMyName(String name) {
    myName.value = name;
  }

  void updateServerIpAddress(String ipAddress) {
    serverIpAddress.value = ipAddress;
  }

  void updateBoss(bool isBoss) {
    this.isBoss.value = isBoss;
  }

  void clearAllInformation() {
    myIpAddress.value = "-";
    myName.value = "-";
    serverIpAddress.value = "-";
    isBoss.value = false;
  }
}