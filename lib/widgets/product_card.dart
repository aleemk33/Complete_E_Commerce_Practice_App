import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../modules/cart/cart_controller.dart';
import '../app/data/models/product_model.dart';
import '../modules/wishlist/wishlist_controller.dart';
import '../app/ui/app_snackbar.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({super.key, required this.product});

  final cartController = Get.find<CartController>();
  final wish = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.product, arguments: product),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "product-${product.id}",
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Image.network(
                      product.image,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Obx(
                    () => IconButton(
                      icon: Icon(
                        wish.isSaved(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        final wasSaved = wish.isSaved(product);
                        wish.toggle(product);
                        if (wasSaved) {
                          AppSnackbar.info(
                            'removed'.tr,
                            '${product.title} ${'removed_from_wishlist'.tr}',
                          );
                        } else {
                          AppSnackbar.success(
                            'saved'.tr,
                            '${product.title} ${'saved_to_wishlist'.tr}',
                          );
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(180),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  crossAxisAlignment: .end,
                  children: [
                    Expanded(
                      child: Text(
                        "\$${product.price}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          cartController.add(product);
                          AppSnackbar.success(
                            'added'.tr,
                            '${product.title} ${'added_to_cart'.tr}',
                          );
                        },
                        child: Text('add'.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
