import 'package:flutter/material.dart';
import 'package:liar_getx/widgets/face_icon/face_info.dart';
import 'package:liar_getx/controller/game_controller.dart';

class FaceRow extends StatelessWidget {
  FaceRow({required this.gameController});
  final GameController gameController;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(child: FaceInfo(name: "얼굴1", nick: gameController.nickListInfo[0]), visible: gameController.imageInfo[0]),
        Visibility(child: FaceInfo(name: "얼굴2", nick: gameController.nickListInfo[1]), visible: gameController.imageInfo[1]),
        Visibility(child: FaceInfo(name: "얼굴3", nick: gameController.nickListInfo[2]), visible: gameController.imageInfo[2]),
        Visibility(child: FaceInfo(name: "얼굴4", nick: gameController.nickListInfo[3]), visible: gameController.imageInfo[3]),
        Visibility(child: FaceInfo(name: "얼굴5", nick: gameController.nickListInfo[4]), visible: gameController.imageInfo[4]),
        Visibility(child: FaceInfo(name: "얼굴6", nick: gameController.nickListInfo[5]), visible: gameController.imageInfo[5]),
      ],
    );
  }
}