import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:get/get.dart';
import 'package:liar_getx/controller/myinfo_controller.dart';
import 'package:liar_getx/controller/form_controller.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({Key? key, required this.title, required this.condition, required this.formKey}) : super(key: key);
  final String title;
  final bool condition;
  final GlobalKey<FormState> formKey; // For SignUp Page, validation check variable

  MyInfoController myInfoController = Get.find<MyInfoController>();
  FormController formController = Get.find<FormController>();

  @override
  Widget build(BuildContext context) {
    return (condition) ? ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
        child: Text(title),
        onPressed: () {
          formKey.currentState!.validate() ? _readOk() : print('No validation check');
        }) : ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
        child: Text(title),
        onPressed: () => _loadIp()
    );
  }

  Future<void> _loadIp() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();
      print("Load IP Address Info :[${data['ip']}]");
      formController.onChangeIp(data['ip']);
      myInfoController.onChange(data['ip']);
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  Future<void> _readOk() async {
    print("준비 ok");
  }
}