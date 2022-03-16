import 'package:get/get.dart';
import 'package:liar_getx/binding/socket_binding.dart';
import 'package:liar_getx/root/routes.dart';
import 'package:liar_getx/pages/start_room.dart';
import 'package:liar_getx/pages/client_home.dart';
import 'package:liar_getx/pages/server_home.dart';
import 'package:liar_getx/pages/make_room.dart';
import 'package:liar_getx/binding/myinfo_binding.dart';
import 'package:liar_getx/binding/form_binding.dart';
import 'package:liar_getx/binding/game_binding.dart';

class Pages {
  static final routes = [
    GetPage(
      name: Routes.STARTROOM,
      page: () => StartRoom(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.MAKEROOM,
      page: () => MakeRoom(),
      bindings: [
        MyInfoBinding(),
        FormBinding(),
        GameBinding(),
        SocketBinding()
      ],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.SERVERHOME,
      page: () => ServerHome(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.CLIENTHOME,
      page: () => ClientHome(),
      transition: Transition.noTransition,
    ),
  ];
}