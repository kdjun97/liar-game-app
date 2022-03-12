import 'package:get/get.dart';

class MyInfoController extends GetxController {
  String myIp = "";

  void onChange(String data) {
    myIp = data;
    update();
  }
}