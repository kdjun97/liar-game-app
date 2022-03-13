import 'package:get/get.dart';
import 'package:liar_getx/controller/game_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameController>(() => GameController());
  }
}