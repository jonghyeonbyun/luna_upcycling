import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:luna_upcycling/controllers/bt_permission_controller.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/pages/light_color_pick.dart';
import 'package:get/get.dart';
class BlueToothPermission extends GetView<BtPermissionController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: controller.isLoading.value ? Center(child: CircularProgressIndicator()): Center(child: Text("블루투스 권한이 허가되지 않았습니다."),));
  }
}
