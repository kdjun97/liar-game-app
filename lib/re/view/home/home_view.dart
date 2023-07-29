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
      title: "게임 진행 도움말",
      middleText: "1. 방장이 방을 만들고 방생성을 한다.\n2. 클라이언트가 접속하기를 눌러 방입장을 한다.\n(이 때, 클라이언트는 서버의 아이피를 다 입력해주어야함.)\n3. 방장이 시작을 누르면 게임 시작.\n\n4. 모든 사람이 제시어를 확인한 후, 제한 시간 내에 제시어에 대해 설명한다.\n5. 라이어는 정체가 들키지 않게 거짓말로 설명한다.\n6. 라이어 마지막 찬스 명령어 [정답:ㅇㅇㅇ]\n7. 투표 때 라이어가 아닌 사람이 뽑히거나, 라이어가 마지막 찬스에서 제시어를 맞히면 라이어의 승리!\n8. 라이어가 제시어를 못맞추면 시민의 승리!",
      textCancel: 'Ok',
      barrierDismissible: false
    );
  }

  void setIpHelperDialog() {
    Get.defaultDialog(
      title: "IP 셋팅 도움말",
      middleText: "아이피 수동 확인법\n무조건 같은 공유기의 같은 와이파이 연결자들만 게임이 가능함.\n설정(환경설정)-연결-연결된 Wi-Fi-더보기-고급-하단에 더보기에 IP주소확인\nex)192.168.0.1",
      textCancel: 'Ok',
      barrierDismissible: false
    );
  }
}