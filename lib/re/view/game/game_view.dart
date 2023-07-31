import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/controller/game_controller.dart';
import 'package:liar_refactoring/controller/socket_controller.dart';
import 'package:liar_refactoring/re/core/manager/user_manager.dart';
import 'package:liar_refactoring/re/core/widgets/custom_app_bar.dart';
import 'package:liar_refactoring/re/view/game/utils/constants.dart';
import 'package:liar_refactoring/re/view/game/widgets/game_menu_button.dart';
import 'package:liar_refactoring/widgets/face_icon/face_row.dart';
import 'package:liar_refactoring/widgets/message/message_list_widget.dart';
import 'package:liar_refactoring/widgets/message/submit_widget.dart';

class GameView extends StatelessWidget {
  GameController gameController = Get.find<GameController>();
  SocketController socketController = Get.find<SocketController>();
  final userManager = Get.find<UserManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gameViewAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              countDownWidget(),
              gameMenuButton(),
            ],
          ),
          GetBuilder<GameController>(builder: (_) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom:BorderSide(width:2, color:Colors.black),
                  top:BorderSide(width:2, color:Colors.black),
                ),
              ),
              child: FaceRow(gameController: gameController), // 유저들 프로필 정보
            );
          }),
          GetBuilder<GameController>(builder: (_) {
            return MessageListWidget(msgList: gameController.msgList);
          }),
          SubmitWidget(),
        ],
      )
    );
  }

  PreferredSizeWidget gameViewAppBar() {
    if (userManager.isServer.value) {
      return CustomAppBar(
        appBar: AppBar() ,
        title: GameViewConstants.serverAppBarTitle,
        backButton: false,
      );
    } else {
      return CustomAppBar(
        appBar: AppBar() ,
        title: GameViewConstants.clientAppBarTitle,
        backButton: false,
      );
    }
  }

  Widget countDownWidget() {
    if (gameController.gameStatus.value == GameStatus.start) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(19.0, 0.0, 0.0, 0.0),
        child: Obx(()=> Text('${GameViewConstants.timeLimit}${gameController.timeLimit.value}')),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(19.0, 0.0, 0.0, 0.0),
        child: Obx(()=> Text('${GameViewConstants.timeLimit}${gameController.timeLimit.value-1}')),
      );
    }
  }
}

enum GameStatus {
  start, stop
}