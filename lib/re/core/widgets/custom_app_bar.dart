import 'package:flutter/material.dart';
import 'package:get/get.dart';

// customized AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.appBar,
    required this.title,
    required this.backButton,
  });

  final AppBar appBar;
  final String title;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: ()=> Get.back()),
      title: Text(title, style : const TextStyle(color: Colors.white)),
      backgroundColor : Colors.black,
      automaticallyImplyLeading: backButton
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}