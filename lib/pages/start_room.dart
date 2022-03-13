import 'package:flutter/material.dart';
import 'package:liar_getx/widgets/custom_raised_button.dart';

// 첫 게임 시작할 때 페이지
class StartRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Image.asset('assets/배너.jpg')
            ),
            const CustomRaisedButton(title: "방만들기", condition: 0),
            const CustomRaisedButton(title: "접속하기", condition: 1),
            const CustomRaisedButton(title: "게임방법", condition: 2),
            const CustomRaisedButton(title: "IP셋팅법", condition: 3),
          ],
        ),
      ),
    );
  }
}