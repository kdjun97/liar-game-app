import 'package:flutter/material.dart';

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
      title: Text(title, style : const TextStyle(color: Colors.white)),
      backgroundColor : Colors.black,
      automaticallyImplyLeading: backButton
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}