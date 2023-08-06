import 'package:flutter/material.dart';
import 'package:liar_refactoring/re/core/utils/helper/form_validation_helper.dart';

class CustomTextFormField extends StatelessWidget
{
  String name;
  TextEditingController controller;
  bool isHideText;
  Size size;

  CustomTextFormField({
    Key? key,
    required this.name,
    required this.controller,
    required this.isHideText,
    required this.size,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB((size.width/2)-100, 0, (size.width/2)-100, 0),
        child: TextFormField(
          validator: (value) {
            if (formValidationCheck(value) == false) {
              return 'Please enter $name';
            }
            return null;
          },
          controller: controller,
          obscureText: isHideText,
          decoration: InputDecoration(
            filled: false,
            labelText: name,
          ),
        )
    );
  }
}