import 'package:get/get.dart';
import 'package:luna_upcycling/controllers/mood_light_controller.dart';

class MoodLightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoodLightController());
  }
}
