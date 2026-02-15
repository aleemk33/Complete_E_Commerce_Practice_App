import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cart/cart_controller.dart';
import '../wishlist/wishlist_controller.dart';
import 'product_controller.dart';
import '../../app/ui/app_snackbar.dart';

class ProductView extends StatelessWidget {
  final controller = Get.find<ProductController>();
  final cart = Get.find<CartController>();
  final wishlist = Get.find<WishlistController>();

  ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = controller.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                wishlist.isSaved(p) ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              // Wishlist toggle is immediate to keep UI snappy.
              onPressed: () => wishlist.toggle(p),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image gallery with page indicator below.
          Hero(
            tag: "product-${p.id}",
            child: AspectRatio(
              aspectRatio: 1.3,
              child: PageView.builder(
                itemCount: (p.images.isEmpty ? [p.image] : p.images).length,
                onPageChanged: (i) => controller.currentImage.value = i,
                itemBuilder: (_, i) {
                  final images = p.images.isEmpty ? [p.image] : p.images;
                  return Image.network(
                    images[i],
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (p.images.isEmpty ? [p.image] : p.images).length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentImage.value == i
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              "\$${p.price}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          // Rating row gives quick quality signal.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  "${p.rating.toStringAsFixed(1)} (${p.reviews} reviews)",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (p.sizes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'size'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (p.sizes.isNotEmpty)
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: p.sizes
                      .map(
                        (s) => ChoiceChip(
                          label: Text(s),
                          selected: controller.selectedSize.value == s,
                          onSelected: (_) => controller.selectedSize.value = s,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          // Color options displayed as chips.
          if (p.colors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'color'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (p.colors.isNotEmpty)
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: p.colors
                      .map(
                        (c) => ChoiceChip(
                          label: Text(c),
                          selected: controller.selectedColor.value == c,
                          onSelected: (_) => controller.selectedColor.value = c,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'description'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              p.description.isEmpty
                  ? 'premium_description'.tr
                  : p.description,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  cart.add(p);
                  AppSnackbar.success(
                    'added'.tr,
                    '${p.title} ${'added_to_cart'.tr}',
                  );
                },
                child: Text('add_to_cart_btn'.tr),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
