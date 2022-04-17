import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';
import 'package:liar_getx/controller/game_controller.dart';
import 'package:liar_getx/utils/custom_app_bar.dart';
import 'package:liar_getx/widgets/message/submit_widget.dart';
import 'package:liar_getx/widgets/message/message_list_widget.dart';
import 'package:liar_getx/controller/socket_controller.dart';
import 'package:liar_getx/widgets/button/game_menu_button.dart';
import 'package:liar_getx/widgets/text/count_down_text.dart';
import 'package:liar_getx/widgets/face_icon/face_row.dart';

class GameHome extends StatelessWidget {
  MyInfoController myInfoController = Get.find<MyInfoController>();
  GameController gameController = Get.find<GameController>();
  SocketController socketController = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (gameController.isServer) ? CustomAppBar(appBar: AppBar() ,title: "서버", backButton: false)
        :  CustomAppBar(appBar: AppBar() ,title: "클라이언트", backButton: false),
      body: Column(
        children: [
          Row(
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0), child: Text("남은시간 :")),
              CountDownText(gameController: gameController), // 남은시간
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0),
                child: GetBuilder<GameController>(builder: (_) {
                  return GameMenuButton(gameController: gameController, socketController: socketController); // 상단 게임 메뉴 버튼
                })
              )
            ],
          ),
          GetBuilder<GameController>(builder: (_) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(bottom:BorderSide(width:2, color:Colors.black),top:BorderSide(width:2, color:Colors.black)),
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
}