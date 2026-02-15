import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'orders_controller.dart';
import 'order_detail_view.dart';

class OrdersView extends StatelessWidget {
  OrdersView({super.key});

  final controller = Get.find<OrdersController>();

  String formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('orders_title'.tr)),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          // Empty state when no orders have been placed yet.
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade500),
                const SizedBox(height: 12),
                Text('no_orders'.tr),
                const SizedBox(height: 4),
                Text(
                  'orders_hint'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final order = controller.orders[i];
            return Card(
              child: ListTile(
                title: Text(
                  'order_number'.trParams({
                    'id': order.id.substring(order.id.length - 6),
                  }),
                ),
                // Show date and address for quick scan.
                subtitle: Text(
                  '${formatDate(order.placedAt)} · ${order.address}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${order.total.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(38),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Status badge is simple for now (Placed).
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => Get.to(() => OrderDetailView(order: order)),
              ),
            );
          },
        );
      }),
    );
  }
}
