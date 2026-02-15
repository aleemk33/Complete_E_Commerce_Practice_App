import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../auth/auth_controller.dart';
import 'profile_edit_view.dart';
import '../../app/ui/app_snackbar.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr)),
      body: Obx(() {
        if (!auth.isLoggedIn) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline,
                      size: 56, color: Colors.grey.shade500),
                  const SizedBox(height: 12),
                  Text('not_signed_in'.tr),
                  const SizedBox(height: 6),
                  Text(
                    'manage_account_hint'.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.login),
                    child: Text('login'.tr),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.signup),
                    child: Text('signup'.tr),
                  ),
                ],
              ),
            ),
          );
        }

        final user = auth.user.value!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage:
                      user.photoUrl == null ? null : NetworkImage(user.photoUrl!),
                  child: user.photoUrl == null
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(user.email,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: Text('orders'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.orders),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text('addresses'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.addresses),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: Text('payment_methods'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text('edit_profile'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.to(() => const ProfileEditView()),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text('settings'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.settings),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text('logout'.tr),
                    onTap: () {
                      auth.logout();
                      AppSnackbar.info('logged_out'.tr, 'see_you'.tr);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
