import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import 'home_controller.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/skeleton_product_card.dart';
import '../../../widgets/skeleton_chip.dart';
import '../cart/cart_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.find<HomeController>();
  final cart = Get.find<CartController>();
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('title'.tr),
            Text(
              'find_subtitle'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Obx(
            () => InkWell(
              onTap: () => Get.toNamed(AppRoutes.cart),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(Icons.shopping_cart_outlined),
                  if (cart.itemCount > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha(46),
                  Theme.of(context).colorScheme.primary.withAlpha(13),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'find_title'.tr,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'find_subtitle'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'search_hint'.tr,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: controller.searchQuery.value.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                searchController.clear();
                                controller.searchQuery.value = '';
                                controller.applyFilters();
                              },
                            ),
                    ),
                    onChanged: (val) {
                      controller.searchQuery.value = val;
                      controller.applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: controller.loading.value
                  ? const Row(
                      children: [
                        SkeletonChip(width: 60),
                        SkeletonChip(width: 78),
                        SkeletonChip(width: 70),
                        SkeletonChip(width: 90),
                      ],
                    )
                  : Row(
                      children: controller.categories
                          .map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(c),
                                selected:
                                    controller.selectedCategory.value == c,
                                onSelected: (_) {
                                  controller.selectedCategory.value = c;
                                  controller.applyFilters();
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    "${controller.displayedProducts.length} ${'items_count'.tr}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Obx(
                  () => TextButton.icon(
                    onPressed: () {
                      controller.sortAscending.toggle();
                      controller.applyFilters();
                    },
                    icon: Icon(
                      controller.sortAscending.value
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                    ),
                    label: Text('price'.tr),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, _) => const SkeletonProductCard(),
                );
              }
              if (controller.displayedProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 12),
                      Text('no_products'.tr),
                      const SizedBox(height: 4),
                      Text(
                        'try_different'.tr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount:
                    controller.displayedProducts.length +
                    (controller.hasMore.value ? 2 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (_, i) {
                  if (i >= controller.displayedProducts.length) {
                    return const SkeletonProductCard();
                  }
                  return ProductCard(product: controller.displayedProducts[i]);
                },
              );
            }),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Get.toNamed(AppRoutes.wishlist);
          if (i == 2) Get.toNamed(AppRoutes.settings);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'wishlist'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'settings'.tr,
          ),
        ],
        // Use theme-provided colors to keep contrast correct in dark mode.
      ),
    );
  }
}
