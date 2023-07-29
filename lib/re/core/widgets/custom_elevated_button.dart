import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.title,
    required this.fontSize,
    this.onClickEvent,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String title;
  final double fontSize;
  final Function()? onClickEvent;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
          onPressed: onClickEvent,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            )
          ),
      ),
    );
  }
}