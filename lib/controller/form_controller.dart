import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FormController extends GetxController {
  late TextEditingController nameController = TextEditingController(); // name
  late TextEditingController srvIpController = TextEditingController(); // Server Ip
  late TextEditingController myIpController = TextEditingController(); // My Ip

  void onChangeIp(String data) {
    myIpController.text = data;
    update();
  }
}