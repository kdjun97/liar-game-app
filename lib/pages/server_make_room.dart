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
      appBar: AppBar(title: Text("방만들기", style : TextStyle(color: Colors.white)), backgroundColor : Colors.black),
      body: Form(
        key: formKey,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child:
                    Image.asset('assets/배너2.jpg'),
                    margin: EdgeInsets.all(10.0)
                  ),
                  GetBuilder<MyInfoController>(builder: (_) {
                    return Text("내 IP : ${myInfoController.myIp}",style: TextStyle(fontSize: 25));
                  }),
                  GetBuilder<FormController>(builder: (_) {
                    return CustomTextFormField(name: '닉네임설정', controller: formController.nameController, obsc: false, size: Size(Get.width, Get.height));
                  }),
                  GetBuilder<FormController>(builder: (_) {
                    return CustomTextFormField(name: '내IP 설정', controller: formController.myIpController, obsc: false, size: Size(Get.width, Get.height));
                  }),
                  /*GetBuilder<FormController>(builder: (_) {
                    return ListTile(
                        leading: const Text(
                            "내 IP 설정  ", style: TextStyle(fontSize: 15)),
                        dense: true,
                        title: CustomTextFormField(
                            controller: formController.myIpController)
                    );
                  }),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomElevatedButton(title: 'Load IP', condition: false, formKey: formKey), // false : Load IP Button
                      CustomElevatedButton(title: '방만들기', condition: true, formKey: formKey), // false : Load IP Button
                    ],
                  )
                ]
            )
        ),
      )
    );
  }
}