import 'package:get/get.dart';
import 'package:liar_getx/root/routes.dart';
import 'package:liar_getx/pages/start_room.dart';
import 'package:liar_getx/pages/client_join.dart';
import 'package:liar_getx/pages/server_home.dart';
import 'package:liar_getx/pages/server_make_room.dart';
import 'package:liar_getx/binding/myinfo_binding.dart';
import 'package:liar_getx/binding/form_binding.dart';

class Pages {
  static final routes = [
    GetPage(
      name: Routes.STARTROOM,
      page: () => StartRoom(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.SERVERMAKEROOM,
      page: () => ServerMakeRoom(),
      bindings: [
        MyInfoBinding(),
        FormBinding()
      ],
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: Routes.SERVERHOME,
      page: () => ServerHome(),
      transition: Transition.noTransition,
    ),
    /*
    GetPage(
      name: Routes.CLIENTJOIN,
      page: () => ClientJoin(),
      binding: SignBinding(),
      transition: Transition.noTransition,
    ),*/

  ];
}