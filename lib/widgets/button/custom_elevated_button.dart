import 'package:flutter/material.dart';
import 'package:liar_getx/func/custom_elevated_button_handle.dart';

/// In make room page, elevated button widget
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key? key, required this.title, required this.condition, required this.formKey}) : super(key: key);
  final String title;
  final bool condition;
  final GlobalKey<FormState> formKey; // For SignUp Page, validation check variable

  @override
  Widget build(BuildContext context) {
    return (condition) ? ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
        child: Text(title),
        onPressed: () {
          formKey.currentState!.validate() ? CustomElevatedButtonHandle().readyOk(title) : print('No validation check');
        }) : ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
        child: Text(title),
        onPressed: () => CustomElevatedButtonHandle().loadIp()
    );
  }
}