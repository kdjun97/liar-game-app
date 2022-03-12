import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/root/pages.dart';
import 'package:liar_getx/root/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.STARTROOM,
      getPages: Pages.routes,
    );
  }


}