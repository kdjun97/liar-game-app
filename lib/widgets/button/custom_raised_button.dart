import 'package:flutter/material.dart';
import 'package:liar_getx/func/custom_raised_button_handle.dart';

// 0 : 방만들기 1 : 접속하기 2 : 게임방법 3 : IP셋팅법
class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({Key? key, required this.title, required this.condition}) : super(key: key);

  final String title;
  final int condition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
      child: RaisedButton(
        child: Text(title,
            style: TextStyle(fontSize: 35, color: Colors.white)
        ),
        color: Colors.black,
        onPressed: () => CustomButtonHandle().buttonCase(condition),
      ),
    );
  }
}