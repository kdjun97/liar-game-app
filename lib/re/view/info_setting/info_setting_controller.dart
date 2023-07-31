import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:liar_refactoring/controller/game_controller.dart';
import 'package:liar_refactoring/re/core/manager/user_manager.dart';
import 'package:liar_refactoring/re/view/info_setting/models/ip_address_model.dart';
import 'package:liar_refactoring/re/view/info_setting/utils/constants.dart';

class InfoSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoSettingController>(() => InfoSettingController());
  }
}

class InfoSettingController extends GetxController {
  TextEditingController nameController = TextEditingController(); // name
  TextEditingController serverIpController = TextEditingController(); // Server Ip
  TextEditingController myIpController = TextEditingController(); // My Ip
  var gameController = Get.find<GameController>();
  var userManager = Get.find<UserManager>();

  Future<void> loadIpButtonClickedEvent() async {
    try {
      String ipAddress = await getIpFromPackage();
      myIpController.text = ipAddress;
      userManager.myIpAddress.value = ipAddress;
      update();
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  Future<String> getIpFromPackage() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      final response = await ipAddress.getIpAddress();
      final ipAddressModel = IpAddressModel.fromJson(response);
      return ipAddressModel.ipAddress;
    } catch (e) {
      return '-';
    }
  }

  void setUserInformation(String title) {
    bool isServer = (title == InfoSettingConstants.infoConnectTitleText) ? false : true;
    userManager.myName.value = nameController.text;
    userManager.isServer.value = isServer;
    setServerIp(isServer);
    gameController.setUser(nameController.text, myIpController.text);
  }

  void setServerIp(bool isServer) {
    if (isServer) {
      userManager.serverIpAddress.value = myIpController.text;
    } else {
      userManager.serverIpAddress.value = serverIpController.text;
    }
  }
}