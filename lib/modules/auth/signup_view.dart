import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import 'auth_controller.dart';
import '../../app/ui/app_snackbar.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final controller = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var hide = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('signup'.tr)),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('create_account_title'.tr,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('join_track'.tr,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'full_name'.tr),
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_name'.tr
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'email'.tr,
                        hintText: 'demo.shop@gmail.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_email'.tr
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'password'.tr,
                        hintText: 'Shop@1234',
                        suffixIcon: IconButton(
                          icon: Icon(
                              hide ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => hide = !hide),
                        ),
                      ),
                      obscureText: hide,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_password'.tr
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() ??
                                    false) {
                                  try {
                                    await controller.signup(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );
                                    AppSnackbar.success(
                                      'account_created'.tr,
                                      'welcome'.tr,
                                    );
                                    final next =
                                        controller.consumePendingRoute();
                                    Get.offNamed(next ?? AppRoutes.profile);
                                  } catch (_) {
                                    AppSnackbar.error(
                                      'signup_failed'.tr,
                                      'please_try_again'.tr,
                                    );
                                  }
                                }
                              },
                  child: controller.loading.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('signup'.tr),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('already_account'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
