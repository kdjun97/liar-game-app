import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/view/game/game_view_controller.dart';
import 'package:liar_refactoring/controller/socket_controller.dart';
import 'package:liar_refactoring/re/core/manager/user_manager.dart';
import 'package:liar_refactoring/re/core/widgets/custom_app_bar.dart';
import 'package:liar_refactoring/re/view/game/utils/constants.dart';
import 'package:liar_refactoring/re/view/game/widgets/game_menu_button.dart';
import 'package:liar_refactoring/re/view/game/widgets/participated_user_list.dart';
import 'package:liar_refactoring/re/view/game/widgets/game_message_list.dart';
import 'package:liar_refactoring/re/view/game/widgets/submit_message_card.dart';

class GameView extends StatelessWidget {
  GameViewController gameController = Get.find<GameViewController>();
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
          GetBuilder<GameViewController>(builder: (_) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom:BorderSide(width:2, color:Colors.black),
                  top:BorderSide(width:2, color:Colors.black),
                ),
              ),
              child: ParticipatedUserList(gameController: gameController), // 유저들 프로필 정보
            );
          }),
          GetBuilder<GameViewController>(builder: (_) {
            return GameMessageList(messageList: gameController.messageList);
          }),
          SubmitMessageCard(),
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

enum ResultPopupStatus {
  correctAnswer, wrongAnswer, whoIsLiarPopup
}