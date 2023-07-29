import 'package:get/get.dart';
import 'package:liar_refactoring/controller/game_controller.dart';

class CustomButtonHandle {
  /// game_home page control button
  void handleGameControlButton(int condition) {
    GameController gameController = Get.find<GameController>();

    if (condition == 0) { // 게임시작 버튼 (서버)
      (gameController.isServerConnect) ? gameController.showWord() :
      Get.snackbar('Error', "생성된 방이 없습니다", snackPosition: SnackPosition.BOTTOM);
    }

    else if (condition == 1) { // 접속하기 버튼 (클라이언트)
      print("방입장");
      gameController.connectToServer();
    }

    else { // 나가기 버튼 (클라이언트)
      print("나가기");
      gameController.disconnectFromServer();
    }
  }
}