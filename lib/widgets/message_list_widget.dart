import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';

class MessageItem
{
  String IPADDRESS; // IP
  String NICKNAME; // name
  String MESSAGE; // message

  // constructor
  MessageItem(this.IPADDRESS, this.NICKNAME, this.MESSAGE);
}

class MessageListWidget extends StatelessWidget {
  MessageListWidget({Key? key, required this.msgList}) : super(key: key);

  MyInfoController myInfoController = Get.find<MyInfoController>();

  final List<MessageItem> msgList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: msgList.length,
        itemBuilder: (context, index)
        {
          MessageItem item = msgList[index];
          return Container(
            alignment: (item.IPADDRESS == myInfoController.myIp)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container (
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (item.IPADDRESS == myInfoController.myIp)
                    ? Colors.blue[100]
                    : Colors.grey[200]),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Text(
                    item.NICKNAME.trim(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    item.MESSAGE.trim(),
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