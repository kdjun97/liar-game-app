import 'package:get/get.dart';

class MyInfoController extends GetxController {
  String myIp = "";

  void _onChange(String data) {
    myIp = data;
    update();
  }
}