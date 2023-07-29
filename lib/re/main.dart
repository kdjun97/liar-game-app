import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/core/manager/user_manager.dart';
import 'package:liar_refactoring/re/core/route/pages.dart';

void main() {
  getDependency();

  runApp(MyApp());
}

void getDependency() {
  Get.put(UserManager(), permanent: true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.HOME,
      getPages: Routes.routes,
    );
  }
}