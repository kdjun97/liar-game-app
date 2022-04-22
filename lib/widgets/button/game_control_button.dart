import 'package:flutter/material.dart';
import 'package:liar_getx/func/custom_raised_button_handle.dart';

class GameControlButton extends StatelessWidget {
  GameControlButton({Key? key, required this.title, required this.condition}) : super(key: key);

  final String title;
  final int condition;

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 0.0, 30.0, 0),
        child: RaisedButton(
          child: Text(title),
          onPressed: () {
            CustomButtonHandle().handleGameControlButton(condition);
          },
        )
    );
  }


}