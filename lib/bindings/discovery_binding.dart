import 'package:get/get.dart';
import 'package:luna_upcycling/controllers/mood_light_controller.dart';

class DiscoveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoodLightController());
  }
}
