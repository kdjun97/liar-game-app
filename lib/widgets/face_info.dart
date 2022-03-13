import 'package:flutter/material.dart';

class FaceInfo extends StatelessWidget {
  const FaceInfo({Key? key, required this.name, required this.nick});

  final String name;
  final String nick;

  @override
  Widget build(BuildContext context) {
    return Column
      (
        children:
        [
          GestureDetector(
            onTap: ()=> print("${nick}을 누름!"),
            child: Container(
              decoration:BoxDecoration(
                  border: Border.all(width:1, color:Colors.black)
              ),
              margin: EdgeInsets.all(5.0),
              child: Image.asset(
                'assets/${name}.jpg',
                width: 35,
                height: 23,
                fit: BoxFit.cover,
              ),
            ),
          ),
          InkWell(
            //onTap: ()=>print('zzzz'), // 여기 지우면 글자 눌렀을 때 안뜸
            child: Text("${nick.trim()}",
              style: TextStyle(
                fontSize: 10.0,
              ),),
          )
        ]
    );
  }
}