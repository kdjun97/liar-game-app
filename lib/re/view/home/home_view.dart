import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/core/utils/constants/asset_image_constant.dart';
import 'package:liar_refactoring/re/core/utils/constants/font_constants.dart';
import 'package:liar_refactoring/re/core/widgets/custom_elevated_button.dart';
import 'package:liar_refactoring/re/view/home/home_viewmodel.dart';
import 'package:liar_refactoring/re/view/home/utils/constants.dart';

// 첫 게임 시작할 때 페이지
class HomeView extends StatelessWidget {
  final homeViewModel = Get.find<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: Image.asset(AssetImageConstant.BANNER_PATH)
              ),
              CustomElevatedButton(
                title: HomeViewConstants.makeRoomText,
                fontSize: FontConstants.mainFontSize,
                onClickEvent: homeViewModel.moveMakeRoom,
                padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
              ),
              CustomElevatedButton(
                title: HomeViewConstants.connectRoomText,
                fontSize: FontConstants.mainFontSize,
                onClickEvent: homeViewModel.moveConnectRoom,
                padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
              ),
              CustomElevatedButton(
                title: HomeViewConstants.howToPlayGameText,
                fontSize: FontConstants.mainFontSize,
                onClickEvent: gameHelperDialog,
                padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
              ),
              CustomElevatedButton(
                title: HomeViewConstants.howToSetIpText,
                fontSize: FontConstants.mainFontSize,
                onClickEvent: setIpHelperDialog,
                padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void gameHelperDialog() {
    Get.defaultDialog(
      title: HomeViewConstants.gameHelperTitle,
      middleText: HomeViewConstants.gameHelperContents,
      textCancel: HomeViewConstants.ok,
      barrierDismissible: false
    );
  }

  void setIpHelperDialog() {
    Get.defaultDialog(
      title: HomeViewConstants.ipSettingHelperTitle,
      middleText: HomeViewConstants.ipSettingHelperContents,
      textCancel: HomeViewConstants.ok,
      barrierDismissible: false
    );
  }
}