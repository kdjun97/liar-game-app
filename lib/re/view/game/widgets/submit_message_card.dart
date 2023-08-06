import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/view/game/game_view_controller.dart';

class SubmitMessageCard extends StatelessWidget {
  GameViewController gameController = Get.find<GameViewController>();

  @override
  Widget build(BuildContext context) {
    return Card (
      child: ListTile (
        title: TextField (
          controller: gameController.submitController,
        ),
        trailing: IconButton (
          icon: const Icon(Icons.send),
          color: Colors.blue,
          disabledColor: Colors.grey,
          onPressed: () => gameController.submitMessageToServer()
          //(socketController.clientSocket.isNotEmpty) ? gameController.submitMessage : null,
        ),
      ),
    );
  }
}