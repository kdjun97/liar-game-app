import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';
import 'package:liar_getx/controller/game_controller.dart';
import 'package:liar_getx/utils/custom_app_bar.dart';
import 'package:liar_getx/widgets/face_info.dart';
import 'package:liar_getx/widgets/submit_widget.dart';
import 'package:liar_getx/widgets/message_list_widget.dart';
import 'package:liar_getx/controller/socket_controller.dart';
import 'package:liar_getx/widgets/game_control_button.dart';

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
              Obx((){
                return (gameController.isServer) ? (
                  (gameController.isGameStart) ? Text("${gameController.time.value}") : Text("${gameController.time.value-1}")
                ) : (
                  (gameController.isGameStart) ? Text("${gameController.time.value}") : Text("${gameController.time.value-1}")
                );
              }),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0),
                child: GetBuilder<GameController>(builder: (_) {
                  return Row(
                    children: [
                      (gameController.isServer) ? GameControlButton(title: "게임시작", condition: 0)
                        : (gameController.isClientConnect) ? GameControlButton(title: "나가기", condition: 2)
                          : GameControlButton(title: "방입장", condition: 1),
                      (gameController.isServer) ?
                      RaisedButton(
                        child: (gameController.isServerConnect) ? const Text("방폭파") : const Text("방생성") ,
                        onPressed: ()=> (gameController.isServerConnect) ? socketController.stopServer() : socketController.startServer(),
                      ) : Container(),
                    ],
                  );
                })
              )
            ],
          ),
          GetBuilder<GameController>(builder: (_) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(bottom:BorderSide(width:2, color:Colors.black),top:BorderSide(width:2, color:Colors.black)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(child: FaceInfo(name: "얼굴1", nick: gameController.nickListInfo[0]), visible: gameController.imageInfo[0]),
                  Visibility(child: FaceInfo(name: "얼굴2", nick: gameController.nickListInfo[1]), visible: gameController.imageInfo[1]),
                  Visibility(child: FaceInfo(name: "얼굴3", nick: gameController.nickListInfo[2]), visible: gameController.imageInfo[2]),
                  Visibility(child: FaceInfo(name: "얼굴4", nick: gameController.nickListInfo[3]), visible: gameController.imageInfo[3]),
                  Visibility(child: FaceInfo(name: "얼굴5", nick: gameController.nickListInfo[4]), visible: gameController.imageInfo[4]),
                  Visibility(child: FaceInfo(name: "얼굴6", nick: gameController.nickListInfo[5]), visible: gameController.imageInfo[5]),
                ],
              ),
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