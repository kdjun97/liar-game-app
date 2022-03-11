import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';
import 'package:liar_getx/controller/form_controller.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:liar_getx/utils/custom_text_field.dart';

// 서버 측 방 만들기 페이지
class ServerMakeRoom extends StatelessWidget {
  MyInfoController myInfoController = Get.find<MyInfoController>();
  FormController formController = Get.find<FormController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("방만들기", style : TextStyle(color: Colors.white)), backgroundColor : Colors.black),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child:
                Image.asset('assets/배너2.jpg'),
                margin: EdgeInsets.all(10.0)
            ),
            GetBuilder<MyInfoController>(builder: (_) {
              return Text("내 IP : ${myInfoController.myIp}",style: TextStyle(fontSize: 25));
            }),
            GetBuilder<FormController>(builder: (_) {
              return ListTile(
                leading: const Text('닉네임설정', style: TextStyle(fontSize: 15)),
                dense: true,
                title: CustomTextField(controller: formController.nameController)
              );
            }),
            GetBuilder<FormController>(builder: (_) {
              return ListTile(
                  leading: const Text(
                      "내 IP 설정  ", style: TextStyle(fontSize: 15)),
                  dense: true,
                  title: CustomTextField(
                    controller: formController.myIpController)
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getIpButton(),
                _readyButton()
              ],
            )


          ]
        )
      )
    );
  }

  Widget _getIpButton() {
    return RaisedButton(
      child: Text("Load IP"),
      onPressed: () async => await _getIp(),
    );
  }

  Future<void> _getIp() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();
      print(data['ip']);
      formController.onChangeIp(data['ip']);
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  Widget _readyButton() {
    return RaisedButton(
      child: Text("준비완료"),
      onPressed: ()=>_readOk(),
    );
  }

  Future<void> _readOk() async {
    print("준비 ok");
  }
}