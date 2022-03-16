import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/game_controller.dart';
import 'package:liar_getx/controller/socket_controller.dart';

class SubmitWidget extends StatelessWidget {
  GameController gameController = Get.find<GameController>();
  SocketController socketController = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Card (
      child: ListTile (
        title: TextField (
          controller: gameController.submitController,
        ),
        trailing: IconButton (
          icon: Icon(Icons.send),
          color: Colors.blue,
          disabledColor: Colors.grey,
          onPressed: () => print("ffffffffffff")
          //(socketController.clientSocket.isNotEmpty) ? gameController.submitMessage : null,
        ),
      ),
    );
  }
}