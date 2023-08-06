import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/view/game/game_view_controller.dart';
import 'package:liar_refactoring/re/core/utils/values/font_values.dart';
import 'package:liar_refactoring/re/core/widgets/custom_elevated_button.dart';
import 'package:liar_refactoring/re/view/game/game_view.dart';
import 'package:liar_refactoring/re/view/game/utils/constants.dart';

extension GameMenuButton on GameView {
  Widget gameMenuButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0),
      child: GetBuilder<GameViewController>(builder: (_) {
        return Row(
          children: [
            serverOrClientFirstButton(),
            forServerSecondButton(),
          ],
        );
      })
    );
  }

  Widget serverOrClientFirstButton() {
    if (userManager.isServer.value) {
      return CustomElevatedButton(
        title: GameViewConstants.gameStart,
        fontSize: FontValues.subFontSize,
        padding: const EdgeInsets.fromLTRB(60.0, 0.0, 30.0, 0),
        onClickEvent: () {
          if (gameController.isConnectedServer) {
            gameController.showWord();
          } else {
            Get.snackbar(
              GameViewConstants.errorMessageTitle,
              GameViewConstants.noRoomErrorContents,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      );
    } else {
      return clientFirstButton();
    }
  }

  Widget clientFirstButton() {
    if (gameController.isConnectedClient) {
      return CustomElevatedButton(
        title: GameViewConstants.leaveRoom,
        fontSize: FontValues.subFontSize,
        padding: const EdgeInsets.fromLTRB(60.0, 0.0, 30.0, 0),
        onClickEvent: () {
          gameController.disconnectFromServer();
        },
      );
    } else {
      return CustomElevatedButton(
        title: GameViewConstants.enterRoom,
        fontSize: FontValues.subFontSize,
        padding: const EdgeInsets.fromLTRB(60.0, 0.0, 30.0, 0),
        onClickEvent: () async {
          await gameController.clientConnectToServer();
        },
      );
    }
  }

  Widget forServerSecondButton() {
    if (userManager.isServer.value) {
      return leaveOrMakeRoomButton();
    } else {
      return Container();
    }
  }

  Widget leaveOrMakeRoomButton() {
    if (gameController.isConnectedServer) {
      return CustomElevatedButton(
        title: GameViewConstants.leaveRoomButtonTitle,
        fontSize: FontValues.subFontSize,
        onClickEvent: () {
          gameController.stopServer();
        },
      );
    } else {
      return CustomElevatedButton(
        title: GameViewConstants.makeRoomButtonTitle,
        fontSize: FontValues.subFontSize,
        onClickEvent: () {
          gameController.startServer();
        },
      );
    }
  }
}