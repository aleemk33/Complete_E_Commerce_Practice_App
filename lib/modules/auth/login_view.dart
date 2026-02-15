import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import 'auth_controller.dart';
import '../../app/ui/app_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailRegex = RegExp(r'^\S+@\S+\.\S+$');
  var hide = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login'.tr)),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('welcome_back'.tr,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('sign_in_continue'.tr,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
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
                          : !_emailRegex.hasMatch(v.trim())
                              ? 'Enter a valid email'
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
                      autofillHints: const [AutofillHints.password],
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
                                    await controller.login(
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );
                                    AppSnackbar.success(
                                      'signed_in'.tr,
                                      'welcome_back'.tr,
                                    );
                                    final next =
                                        controller.consumePendingRoute();
                                    Get.offNamed(next ?? AppRoutes.profile);
                                  } catch (_) {
                                    AppSnackbar.error(
                                      'login_failed'.tr,
                                      'User with that gmail does not exists',
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
                      : Text('login'.tr),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.signup),
              child: Text('create_account'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
