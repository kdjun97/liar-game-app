import 'package:get/get.dart';
import 'package:liar_getx/controller/game_controller.dart';

/// onPressed widgets/button/custom_raised_button
/// OnPressed widgets/button/game_control_button
/// In start_room page, handle action when button pressed
/// In game_home page, handle action when button pressed
class CustomButtonHandle {
  /// start_room page control button
  void buttonCase(int num) {
    switch (num) {
      case 0:
        Get.toNamed('/MakeRoom', arguments: "방만들기");
        break;
      case 1:
        Get.toNamed('/MakeRoom',arguments: "접속하기");
        break;
      case 2:
        Get.defaultDialog(
            title: "게임 진행 도움말",
            middleText: "1. 방장이 방을 만들고 방생성을 한다.\n2. 클라이언트가 접속하기를 눌러 방입장을 한다.\n(이 때, 클라이언트는 서버의 아이피를 다 입력해주어야함.)\n3. 방장이 시작을 누르면 게임 시작.\n\n4. 모든 사람이 제시어를 확인한 후, 제한 시간 내에 제시어에 대해 설명한다.\n5. 라이어는 정체가 들키지 않게 거짓말로 설명한다.\n6. 라이어 마지막 찬스 명령어 [정답:ㅇㅇㅇ]\n7. 투표 때 라이어가 아닌 사람이 뽑히거나, 라이어가 마지막 찬스에서 제시어를 맞히면 라이어의 승리!\n8. 라이어가 제시어를 못맞추면 시민의 승리!",
            textCancel: 'Ok'
        );
        break;
      case 3:
        Get.defaultDialog(
            title: "IP 셋팅 도움말",
            middleText: "아이피 수동 확인법\n무조건 같은 공유기의 같은 와이파이 연결자들만 게임이 가능함.\n설정(환경설정)-연결-연결된 Wi-Fi-더보기-고급-하단에 더보기에 IP주소확인\nex)192.168.0.1",
            textCancel: 'Ok'
        );
        break;
      default:
        print("Error Case");
    }
  }

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