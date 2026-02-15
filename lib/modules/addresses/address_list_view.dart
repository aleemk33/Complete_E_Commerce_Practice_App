import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'address_controller.dart';
import 'address_form_view.dart';

class AddressListView extends StatelessWidget {
  AddressListView({super.key});

  final controller = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('addresses'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddressFormView()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 48,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 12),
                Text('no_addresses'.tr),
                const SizedBox(height: 4),
                Text(
                  'addresses_hint'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final address = controller.addresses[i];
            return Card(
              child: ListTile(
                title: Text(address.label),
                subtitle: Text(
                  '${address.line1}, ${address.city} ${address.zip}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(() => AddressFormView(address: address));
                    }
                    if (value == 'delete') {
                      controller.remove(address);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text('edit'.tr)),
                    PopupMenuItem(value: 'delete', child: Text('delete'.tr)),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
