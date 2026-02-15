import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import 'cart_controller.dart';
import '../../app/ui/app_snackbar.dart';

class CartView extends StatelessWidget {
  final cart = Get.find<CartController>();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('cart'.tr)),
      body: Obx(() {
        if (cart.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 48, color: Colors.grey.shade500),
                const SizedBox(height: 12),
                Text('cart_empty'.tr),
                const SizedBox(height: 4),
                Text(
                  'cart_empty_hint'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (_, i) {
                  final item = cart.items[i];
                  return ListTile(
                    leading: Image.network(item.product.image),
                    title: Text(item.product.title),
                    subtitle: Text("\$${item.product.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            final willRemove = item.qty == 1;
                            cart.decrease(item);
                            if (willRemove) {
                              AppSnackbar.info(
                                'removed'.tr,
                                '${item.product.title} ${'removed_from_cart'.tr}',
                              );
                            }
                          },
                        ),
                        Text("${item.qty}"),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cart.increase(item);
                            AppSnackbar.success(
                              'updated'.tr,
                              '${item.product.title} ${'qty_increased'.tr}',
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "${'total'.tr}: \$${cart.total.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.checkout),
                      child: Text('checkout_btn'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
