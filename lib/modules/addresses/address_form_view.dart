import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/data/models/address_model.dart';
import 'address_controller.dart';

class AddressFormView extends StatefulWidget {
  final Address? address;
  const AddressFormView({super.key, this.address});

  @override
  State<AddressFormView> createState() => _AddressFormViewState();
}

class _AddressFormViewState extends State<AddressFormView> {
  final controller = Get.find<AddressController>();
  final formKey = GlobalKey<FormState>();
  final labelController = TextEditingController();
  final line1Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    if (a != null) {
      labelController.text = a.label;
      line1Controller.text = a.line1;
      cityController.text = a.city;
      zipController.text = a.zip;
    }
  }

  @override
  void dispose() {
    labelController.dispose();
    line1Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.address != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'edit_address'.tr : 'add_address'.tr),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      controller: labelController,
                      decoration: InputDecoration(labelText: 'label'.tr),
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'enter_label'.tr
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: line1Controller,
                      decoration: InputDecoration(labelText: 'address_line'.tr),
                      textInputAction: TextInputAction.next,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_address'.tr
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(labelText: 'city'.tr),
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          v == null || v.trim().isEmpty
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
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'enter_zip'.tr
                              : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final id = editing
                        ? widget.address!.id
                        : DateTime.now().millisecondsSinceEpoch.toString();
                    final address = Address(
                      id: id,
                      label: labelController.text.trim(),
                      line1: line1Controller.text.trim(),
                      city: cityController.text.trim(),
                      zip: zipController.text.trim(),
                    );
                    if (editing) {
                      controller.edit(address);
                    } else {
                      controller.add(address);
                    }
                    Get.back();
                  }
                },
                child: Text(editing ? 'save'.tr : 'add'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
