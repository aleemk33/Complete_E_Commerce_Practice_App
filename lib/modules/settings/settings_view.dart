import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';

class SettingsView extends StatelessWidget {
  final themeController = Get.find<ThemeController>();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('appearance'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: Text('dark_mode'.tr),
              value: themeController.themeMode.value == ThemeMode.dark,
              onChanged: (_) => themeController.toggleTheme(),
            ),
          ),
          const SizedBox(height: 16),
          Text('language'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('english'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.updateLocale(const Locale('en')),
                ),
                const Divider(height: 0),
                ListTile(
                  title: Text('hindi'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.updateLocale(const Locale('hi')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
