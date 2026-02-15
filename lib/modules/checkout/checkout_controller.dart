import 'package:get/get.dart';
import '../cart/cart_controller.dart';
import '../../app/data/models/order_model.dart';
import '../../app/data/repositories/order_repository.dart';

/// Checkout controller: builds orders from cart items.
class CheckoutController extends GetxController {
  final cart = Get.find<CartController>();
  final paymentMethod = 'Card'.obs;
  final orderRepo = OrderRepository();

  Order placeOrder({required String address}) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      placedAt: DateTime.now(),
      address: address,
      status: 'Placed',
      total: cart.total,
      items: cart.items
          .map((e) => OrderItem(
                title: e.product.title,
                price: e.product.price,
                qty: e.qty,
              ))
          .toList(),
    );
    orderRepo.add(order);
    cart.clear();
    return order;
  }
}
