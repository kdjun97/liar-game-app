import 'package:flutter/material.dart';
import 'package:liar_refactoring/re/core/utils/values/font_values.dart';
import 'package:liar_refactoring/re/view/game/game_view_controller.dart';
import 'package:liar_refactoring/re/view/game/utils/constants.dart';

class ParticipatedUserList extends StatelessWidget {
  ParticipatedUserList({required this.gameController});

  final GameViewController gameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView.builder(
          scrollDirection: Axis.horizontal, // 가로 스크롤 설정
          itemCount: GameViewConstants.maxGamePlayer,
          itemBuilder: (context, index) {
            return Visibility(
              visible: gameController.gameUserList[index].isAvatarVisible,
              child: eachUserAvatar(
                "얼굴$index",
                gameController.gameUserList[index].nickName,
              ),
            );
          }
        )
      ],
    );
  }

  Widget eachUserAvatar(String assetName, String nickName) {
    return GestureDetector(
      onTap: () => print("$nickName을 누름!"),
      child: Column(children: [
        GestureDetector(
          child: Container(
            decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            margin: const EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/$assetName.jpg',
              width: 35,
              height: 25,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          nickName.trim(),
          style: const TextStyle(
            fontSize: FontValues.avatarTextSize,
          ),
        ),
      ]),
    );
  }
}
