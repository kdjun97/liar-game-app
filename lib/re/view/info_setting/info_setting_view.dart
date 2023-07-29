import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/controller/myinfo_controller.dart';
import 'package:liar_refactoring/re/core/route/pages.dart';
import 'package:liar_refactoring/re/core/utils/constants/asset_image_constant.dart';
import 'package:liar_refactoring/re/core/utils/constants/font_constants.dart';
import 'package:liar_refactoring/re/core/widgets/custom_app_bar.dart';
import 'package:liar_refactoring/re/core/widgets/custom_elevated_button.dart';
import 'package:liar_refactoring/re/view/info_setting/info_setting_controller.dart';
import 'package:liar_refactoring/re/view/info_setting/utils/constants.dart';
import 'package:liar_refactoring/widgets/custom_text_form_field.dart';

class InfoSettingView extends StatelessWidget {
  MyInfoController myInfoController = Get.find<MyInfoController>();
  final infoSettingController = Get.find<InfoSettingController>();
  final formKey = GlobalKey<FormState>(); // For SignUp Page, validation check variable
  String title = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar() ,title: title, backButton: false),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Image.asset(AssetImageConstant.BANNER2_PATH),
          GetBuilder<MyInfoController>(builder: (_) {
            return Column(
              children: [
                Text("내 IP : ${myInfoController.myIp}",style: const TextStyle(fontSize: 25)),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        name: InfoSettingConstants.setNicknameText,
                        controller: infoSettingController.nameController,
                        isHideText: false,
                        size: Size(Get.width, Get.height)
                      ),
                      (title == InfoSettingConstants.infoConnectTitleText) ?
                        CustomTextFormField(
                          name: InfoSettingConstants.setServerIpText,
                          controller: infoSettingController.serverIpController,
                          isHideText: false,
                          size: Size(Get.width, Get.height)
                        ) : Container(),
                      CustomTextFormField(
                        name: InfoSettingConstants.setMyIpText,
                        controller: infoSettingController.myIpController,
                        isHideText: false,
                        size: Size(Get.width, Get.height)
                      )
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
                title: InfoSettingConstants.loadIpText,
                fontSize: FontConstants.subFontSize,
                onClickEvent: () async {
                  await infoSettingController.loadIpButtonClickedEvent();
                },
              ), // false : Load IP Button
              CustomElevatedButton(
                  title: title,
                  fontSize: FontConstants.subFontSize,
                  onClickEvent: () {
                    FormState? currentState = formKey.currentState;
                    if (currentState == null) return;
                    else {
                      if (currentState.validate()) {
                        infoSettingController.setUserInformation(title);
                        Get.toNamed(RoutesName.GAMEHOME);
                      }
                    }
                  }
              ),
            ],
          )
        ],
      )
    );
  }
}