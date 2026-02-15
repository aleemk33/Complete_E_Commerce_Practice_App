import 'package:get/get.dart';
import '../../modules/addresses/address_controller.dart';

/// Address module bindings.
class AddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
