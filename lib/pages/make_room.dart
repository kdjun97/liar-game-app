import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/controller/form_controller.dart';
import 'package:liar_refactoring/controller/myinfo_controller.dart';
import 'package:liar_refactoring/func/custom_elevated_button_handle.dart';
import 'package:liar_refactoring/re/core/utils/constants/font_constants.dart';
import 'package:liar_refactoring/utils/custom_app_bar.dart';
import 'package:liar_refactoring/re/core/widgets/custom_elevated_button.dart';
import 'package:liar_refactoring/widgets/custom_text_form_field.dart';

// 서버 측 방 만들기 페이지
class MakeRoom extends StatelessWidget {
  MyInfoController myInfoController = Get.find<MyInfoController>();
  FormController formController = Get.find<FormController>();
  final formKey = GlobalKey<FormState>(); // For SignUp Page, validation check variable
  String title = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar() ,title: title, backButton: false),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Image.asset('assets/배너2.png'),
          GetBuilder<MyInfoController>(builder: (_) {
            return Column(
              children: [
                Text("내 IP : ${myInfoController.myIp}",style: const TextStyle(fontSize: 25)),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(name: '닉네임설정', controller: formController.nameController, obsc: false, size: Size(Get.width, Get.height)),
                      (title == "접속하기") ?
                        CustomTextFormField(name: '서버IP 설정', controller: formController.srvIpController, obsc: false, size: Size(Get.width, Get.height))
                          : Container(),
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
              CustomElevatedButton(
                  title: 'Load IP',
                  fontSize: FontConstants.subFontSize,
                  onClickEvent: () {
                    CustomElevatedButtonHandle().loadIp();
                  },
              ), // false : Load IP Button
              CustomElevatedButton(
                  title: title,
                  fontSize: FontConstants.subFontSize,
                  onClickEvent: () {
                    formKey.currentState!.validate() ? CustomElevatedButtonHandle().readyOk(title) : print('No validation check');
                  }
              ), // false : Load IP Button
            ],
          )
        ],
      )
    );
  }
}