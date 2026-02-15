import 'package:get/get.dart';
import '../../modules/home/home_controller.dart';

/// Home module bindings.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
