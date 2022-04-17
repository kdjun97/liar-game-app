import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/game_controller.dart';

class GameControlButton extends StatelessWidget {
  GameControlButton({Key? key, required this.title, required this.condition}) : super(key: key);

  GameController gameController = Get.find<GameController>();

  final String title;
  final int condition;

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 0.0, 30.0, 0),
        child: RaisedButton(
          child: Text(title),
          onPressed: () {
            handleFunc(condition);
          },
        )
    );
  }

  void handleFunc(int condition) {
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