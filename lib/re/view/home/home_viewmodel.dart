import 'package:get/get.dart';
import 'package:liar_refactoring/re/core/route/pages.dart';
import 'package:liar_refactoring/re/view/home/utils/constants.dart';

class HomeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(() => HomeViewModel());
  }
}

class HomeViewModel {
  void moveMakeRoom() {
    Get.toNamed(RoutesName.MAKEROOM, arguments: HomeViewConstants.makeRoomText);
  }

  void moveConnectRoom() {
    Get.toNamed(RoutesName.MAKEROOM, arguments: HomeViewConstants.connectRoomText);
  }
}