import '../models/order_model.dart';
import '../services/order_service.dart';

/// Repository for order data.
class OrderRepository {
  final OrderService service;
  OrderRepository({OrderService? service}) : service = service ?? OrderService();

  List<Order> all() => service.all();

  void add(Order order) => service.add(order);
}
