import 'package:get/get.dart';
import '../../modules/checkout/checkout_controller.dart';
import '../../modules/addresses/address_controller.dart';

/// Checkout bindings (checkout + address storage).
class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
