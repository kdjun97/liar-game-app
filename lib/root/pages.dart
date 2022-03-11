import 'package:get/get.dart';
import 'package:liar_getx/root/routes.dart';
import 'package:liar_getx/pages/start_room.dart';
import 'package:liar_getx/pages/client_join.dart';
import 'package:liar_getx/pages/server_make_room.dart';
class Pages {
  static final routes = [
    GetPage(
      name: Routes.STARTROOM,
      page: () => StartRoom(),
      bindings: [
        //SignBinding()
      ],
      transition: Transition.noTransition,
    ),/*
    GetPage(
      name: Routes.CLIENTJOIN,
      page: () => ClientJoin(),
      binding: SignBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.SERVERMAKEROOM,
      page: () => ServerMakeRoom(),
      binding: CDEBinding(),
      transition: Transition.leftToRight,
    )*/
  ];
}