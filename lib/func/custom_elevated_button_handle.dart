import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:liar_refactoring/controller/form_controller.dart';
import 'package:liar_refactoring/controller/game_controller.dart';
import 'package:liar_refactoring/controller/myinfo_controller.dart';

/// onPressed widgets/custom_elevated_button
/// In make_room page, handle action when button pressed
class CustomElevatedButtonHandle {
  /// Load IP (아이피 불러오기 버튼)
  Future<void> loadIp() async {
    MyInfoController myInfoController = Get.find<MyInfoController>();
    FormController formController = Get.find<FormController>();

    try {
      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();
      print("Load IP Address Info :[${data['ip']}]");
      formController.onChangeIp(data['ip']);
      myInfoController.onChangeIp(data['ip']);
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  /// readOk (방만들기 or 접속하기 버튼)
  Future<void> readyOk(String title) async {
    MyInfoController myInfoController = Get.find<MyInfoController>();
    FormController formController = Get.find<FormController>();
    GameController gameController = Get.find<GameController>();

    myInfoController.setMyName(formController.nameController.text);
    // Server Page
    if (title == "방만들기") {
      myInfoController.setSrvIp(formController.myIpController.text);
      gameController.setServer(true); // 서버 셋팅
      gameController.setUser(formController.nameController.text, formController.myIpController.text);
      Get.toNamed('/GameHome');
    }
    else { // Client Page
      // Client 접속 시, 로직 변경해야할 수 있음.
      gameController.setServer(false); // 클라이언트 셋팅
      myInfoController.setSrvIp(formController.srvIpController.text);
      Get.toNamed('/GameHome');
    }
  }
}