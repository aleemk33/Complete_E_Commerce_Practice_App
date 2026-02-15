import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/models/order_model.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;
  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('order_details'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card with order id, date, and status.
          Card(
            child: ListTile(
              title: Text(
                'order_number'.trParams({
                  'id': order.id.substring(order.id.length - 6),
                }),
              ),
              subtitle: Text(
                '${order.placedAt.day.toString().padLeft(2, '0')}/'
                '${order.placedAt.month.toString().padLeft(2, '0')}/'
                '${order.placedAt.year}',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Shipping address block.
          Text(
            'shipping_address'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(child: ListTile(title: Text(order.address))),
          const SizedBox(height: 12),
          // Items list with computed totals.
          Text('items'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ...order.items.map(
                  (item) => ListTile(
                    title: Text(item.title),
                    subtitle: Text('${'qty'.tr}: ${item.qty}'),
                    trailing: Text(
                      '\$${(item.price * item.qty).toStringAsFixed(2)}',
                    ),
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  title: Text('total'.tr),
                  trailing: Text('\$${order.total.toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
