import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:luna_upcycling/bindings/discovery_binding.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
class BtPermissionController extends GetxController {
  RxBool isAllowedBt = false.obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() async {
    super.onInit();
    isAllowedBt.value = await FlutterBluetoothSerial.instance.requestEnable() ?? false;
    if(isAllowedBt.value){
      print(isAllowedBt);
      Get.offAll(DiscoveryPage(), binding: DiscoveryBinding());
    }
  }
}