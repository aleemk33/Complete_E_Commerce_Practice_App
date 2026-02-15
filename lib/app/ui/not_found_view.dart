import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

/// Fallback screen for unknown routes.
class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade500),
              const SizedBox(height: 12),
              Text('not_found'.tr),
              const SizedBox(height: 6),
              Text(
                'not_found_hint'.tr,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                child: Text('go_home'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
