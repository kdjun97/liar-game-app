import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';
import 'package:liar_getx/controller/form_controller.dart';
import 'package:liar_getx/widgets/custom_elevated_button.dart';
import 'package:liar_getx/widgets/custom_text_form_field.dart';

// 서버 측 방 만들기 페이지
class ServerMakeRoom extends StatelessWidget {
  MyInfoController myInfoController = Get.find<MyInfoController>();
  FormController formController = Get.find<FormController>();
  final formKey = GlobalKey<FormState>(); // For SignUp Page, validation check variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("방만들기", style : TextStyle(color: Colors.white)), backgroundColor : Colors.black),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Image.asset('assets/배너2.jpg'),
          GetBuilder<MyInfoController>(builder: (_) {
            return Column(
              children: [
                Text("내 IP : ${myInfoController.myIp}",style: const TextStyle(fontSize: 25)),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(name: '닉네임설정', controller: formController.nameController, obsc: false, size: Size(Get.width, Get.height)),
                      CustomTextFormField(name: '내IP 설정', controller: formController.myIpController, obsc: false, size: Size(Get.width, Get.height))
                    ],
                  )
                )
              ],
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomElevatedButton(title: 'Load IP', condition: false, formKey: formKey), // false : Load IP Button
              CustomElevatedButton(title: '방만들기', condition: true, formKey: formKey), // false : Load IP Button
            ],
          )
        ],
      )
    );
  }
}