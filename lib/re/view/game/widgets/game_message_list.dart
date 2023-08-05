import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/core/manager/user_manager.dart';
import 'package:liar_refactoring/re/view/game/model/message_model.dart';


class GameMessageList extends StatelessWidget {
  GameMessageList({Key? key, required this.messageList}) : super(key: key);

  final List<MessageModel> messageList;
  final userManager = Get.find<UserManager>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messageList.length,
        itemBuilder: (context, index)
        {
          MessageModel item = messageList[index];
          return Container(
            alignment: (item.ipAddress == userManager.myIpAddress.value)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container (
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (item.ipAddress == userManager.myIpAddress.value)
                    ? Colors.blue[100]
                    : Colors.grey[200]),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Text(
                    item.nickName.trim(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    item.message.trim(),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        }),
    );
  }
}