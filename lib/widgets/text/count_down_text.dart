import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/game_controller.dart';

/// 남은시간 카운트 해주는 위젯
class CountDownText extends StatelessWidget {
  CountDownText({required this.gameController});

  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (gameController.isServer)
          ? ((gameController.isGameStart)
              ? Text("${gameController.time.value}")
              : Text("${gameController.time.value - 1}"))
          : ((gameController.isGameStart)
              ? Text("${gameController.time.value}")
              : Text("${gameController.time.value - 1}"));
    });
  }
}
