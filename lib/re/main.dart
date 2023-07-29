import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_refactoring/re/core/route/pages.dart';
import 'package:liar_refactoring/re/view/home/home_viewmodel.dart';

void main() {
  getDependency();

  runApp(MyApp());
}

void getDependency() {
  Get.put(HomeViewModel(), permanent: true);
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