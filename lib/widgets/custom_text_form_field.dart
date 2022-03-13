import 'package:flutter/material.dart';

// Customizing한 TextFormField임. validation 체크까지 다 가능
// 1st param = title, 2nd param = TextEditingController, 3rd param = 비밀번호 가리개, 4th param = size
class CustomTextFormField extends StatelessWidget
{
  late String name;
  TextEditingController controller;
  bool obsc;
  Size size;

  CustomTextFormField({
    Key? key,
    required this.name,
    required this.controller,
    required this.obsc,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB((size.width/2)-100, 0, (size.width/2)-100, 0),
        child: TextFormField
        (
          validator: (value)
          {
            if (value == null || value.isEmpty) {
              return 'Please enter $name';
            }
            return null;
          },
          controller: controller,
          obscureText: obsc,
          decoration: InputDecoration(
            filled: false,
            labelText: name,
          ),
        )
    );
  }
}