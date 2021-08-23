import 'package:get/get.dart';
import 'package:luna_upcycling/controllers/bt_permission_controller.dart';
import 'package:luna_upcycling/controllers/mood_light_controller.dart';

class BtPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BtPermissionController());
  }
}
