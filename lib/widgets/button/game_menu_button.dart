import 'package:flutter/material.dart';
import 'package:liar_getx/widgets/button/game_control_button.dart';
import 'package:liar_getx/controller/game_controller.dart';
import 'package:liar_getx/controller/socket_controller.dart';

/// 게임 홈 상단 메뉴 버튼
class GameMenuButton extends StatelessWidget {
  GameMenuButton(
      {required this.gameController, required this.socketController});

  final GameController gameController;
  final SocketController socketController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (gameController.isServer)
            ? GameControlButton(title: "게임시작", condition: 0)
            : (gameController.isClientConnect)
                ? GameControlButton(title: "나가기", condition: 2)
                : GameControlButton(title: "방입장", condition: 1),
        (gameController.isServer)
            ? RaisedButton(
                // TODO: 추후 방 폭파를 눌렀을 때 흘러가는 timer도 잡아줘야함.
                child: (gameController.isServerConnect)
                    ? const Text("방폭파")
                    : const Text("방생성"),
                onPressed: () => (gameController.isServerConnect)
                    ? socketController.stopServer()
                    : socketController.startServer(),
              )
            : Container(),
      ],
    );
  }
}
