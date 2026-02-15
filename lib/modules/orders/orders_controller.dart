import 'package:get/get.dart';
import '../../app/data/models/order_model.dart';
import '../../app/data/repositories/order_repository.dart';

/// Orders controller for list and insert operations.
class OrdersController extends GetxController {
  final repo = OrderRepository();
  final orders = <Order>[].obs;

  @override
  void onInit() {
    orders.value = repo.all();
    super.onInit();
  }

  void add(Order order) {
    repo.add(order);
    orders.insert(0, order);
  }
}
