import 'package:get/get.dart';
import '../../modules/orders/orders_controller.dart';

/// Orders module bindings.
class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
