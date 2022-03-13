import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';
import 'package:liar_getx/utils/custom_app_bar.dart';

class ServerHome extends StatelessWidget {
  MyInfoController myInfoController = Get.find<MyInfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar() ,title: "서버", backButton: false),
      body: Column(
        children: [
          Container(child:Text("내 IP :${myInfoController.myIp}"),margin : EdgeInsets.only(top:30.0)),
        ],
      ),
    );
  }
}