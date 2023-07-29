import 'package:get/get.dart';

class MyInfoController extends GetxController {
  String myIp = "";
  String myName = "";
  String srvIp = ""; // 서버 아이피

  void onChangeIp(String data) {
    myIp = data;
    update();
  }

  void setMyName(String data) {
    myName = data;
  }

  void setSrvIp(String data) {
    srvIp = data;
  }
}