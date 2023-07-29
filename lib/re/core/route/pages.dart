import 'package:get/get.dart';
import 'package:liar_refactoring/binding/game_binding.dart';
import 'package:liar_refactoring/binding/myinfo_binding.dart';
import 'package:liar_refactoring/binding/socket_binding.dart';
import 'package:liar_refactoring/pages/game_home.dart';
import 'package:liar_refactoring/re/view/info_setting/info_setting_controller.dart';
import 'package:liar_refactoring/re/view/info_setting/info_setting_view.dart';
import 'package:liar_refactoring/re/view/home/home_view.dart';

class RoutesName {
  static const HOME = '/Home'; // 처음 시작 때 방 고르는 페이지
  static const INFOSETTING = '/InfoSetting'; // 서버, 클라 방 만들기 or 접속하기 페이지
  static const GAMEHOME = '/GameHome'; // 서버 홈, 클라 홈
}

class Routes {
  static final routes = [
    GetPage(
      name: RoutesName.HOME,
      page: () => HomeView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RoutesName.INFOSETTING,
      page: () => InfoSettingView(),
      bindings: [
        InfoSettingBinding(),
        MyInfoBinding(),
        GameBinding(),
        SocketBinding()
      ],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RoutesName.GAMEHOME,
      page: () => GameHome(),
      transition: Transition.noTransition,
    ),
  ];
}