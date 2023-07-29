import 'package:get/get.dart';
import 'package:liar_refactoring/controller/socket_controller.dart';

class SocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocketController>(() => SocketController());
  }
}