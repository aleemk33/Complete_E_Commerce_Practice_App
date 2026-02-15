import 'package:get_storage/get_storage.dart';
import '../models/order_model.dart';

/// Local storage-backed order service.
class OrderService {
  final box = GetStorage();

  List<Order> all() {
    final data = box.read('orders');
    if (data == null) return [];
    return List<Map>.from(data).map((e) => Order.fromJson(e)).toList();
  }

  void add(Order order) {
    final orders = all();
    orders.insert(0, order);
    box.write('orders', orders.map((e) => e.toJson()).toList());
  }
}
