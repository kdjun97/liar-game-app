import 'package:get/get.dart';
import 'package:liar_refactoring/controller/myinfo_controller.dart';

class MyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyInfoController>(() => MyInfoController());
  }
}