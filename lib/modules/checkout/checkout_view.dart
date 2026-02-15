import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../cart/cart_controller.dart';
import 'checkout_controller.dart';
import '../addresses/address_controller.dart';
import '../../app/data/models/address_model.dart';
import '../../app/routes/app_routes.dart';
import '../../app/ui/app_snackbar.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final controller = Get.find<CheckoutController>();
  final cart = Get.find<CartController>();
  final addressStore = Get.find<AddressController>();
  final formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  bool saveAddress = true;

  @override
  void dispose() {
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('checkout_title'.tr)),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Address section: validates delivery info before order placement.
            Text(
              'shipping_address'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'address'.tr),
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.streetAddressLine1],
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_address'.tr
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(labelText: 'city'.tr),
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.addressCity],
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_city'.tr
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: zipController,
                      decoration: InputDecoration(labelText: 'zip'.tr),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.postalCode],
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'enter_zip'.tr : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Payment selection is UI-only (no real gateway).
            Text(
              'payment_method'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Obx(
                () => RadioGroup<String>(
                  groupValue: controller.paymentMethod.value,
                  onChanged: (value) =>
                      controller.paymentMethod.value = value ?? 'Card',
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Card',
                        title: Text('card'.tr),
                      ),
                      const Divider(height: 0),
                      RadioListTile<String>(
                        value: 'UPI',
                        title: Text('upi'.tr),
                      ),
                      const Divider(height: 0),
                      RadioListTile<String>(
                        value: 'COD',
                        title: Text('cod'.tr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Optional preference to persist address.
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('save_address'.tr),
              value: saveAddress,
              onChanged: (v) => setState(() => saveAddress = v),
            ),
            const SizedBox(height: 12),
            // Summary reflects current cart state in real time.
            Text(
              'order_summary'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Obx(
                () => Column(
                  children: [
                    ...cart.items.map(
                      (item) => ListTile(
                        title: Text(item.product.title),
                        subtitle: Text('${'qty'.tr}: ${item.qty}'),
                        trailing: Text(
                          '\$${(item.product.price * item.qty).toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: Text('total'.tr),
                      trailing: Text('\$${cart.total.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  // Block submission when cart is empty.
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          if (formKey.currentState?.validate() ?? false) {
                            final address =
                                '${addressController.text.trim()}, ${cityController.text.trim()} ${zipController.text.trim()}';
                            final order = controller.placeOrder(
                              address: address,
                            );
                            // Save the address for next checkout if opted in.
                            if (saveAddress) {
                              addressStore.add(
                                Address(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  label: 'Home',
                                  line1: addressController.text.trim(),
                                  city: cityController.text.trim(),
                                  zip: zipController.text.trim(),
                                ),
                              );
                            }
                            AppSnackbar.success(
                              'order_placed'.tr,
                              'order_confirmed'.trParams({
                                'id': order.id.substring(order.id.length - 6),
                              }),
                            );
                            // Route to Orders list to show the new order.
                            Get.offNamed(AppRoutes.orders);
                          }
                        },
                  child: Text('place_order'.tr),
                ),
              ),
            ),
            if (cart.items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'cart_empty_checkout'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
