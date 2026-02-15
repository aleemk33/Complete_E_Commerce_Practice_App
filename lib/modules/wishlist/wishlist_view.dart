import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/product_card.dart';
import 'wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  final controller = Get.find<WishlistController>();

  WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('wishlist'.tr)),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 48,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 12),
                Text('wishlist_empty'.tr),
                const SizedBox(height: 4),
                Text(
                  'wishlist_hint'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (_, i) => ProductCard(product: controller.items[i]),
        );
      }),
    );
  }
}
