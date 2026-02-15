import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Centralized snackbars for consistent UX feedback.
class AppSnackbar {
  static void success(String title, String message, {bool haptic = true}) {
    _show(title, message,
        background: Get.theme.colorScheme.primary, haptic: haptic);
  }

  static void info(String title, String message, {bool haptic = false}) {
    _show(title, message,
        background: Get.theme.colorScheme.secondary, haptic: haptic);
  }

  static void error(String title, String message, {bool haptic = true}) {
    _show(title, message,
        background: Colors.red.shade600, haptic: haptic);
  }

  /// Internal helper to standardize styling and haptic feedback.
  static void _show(String title, String message,
      {required Color background, bool haptic = false}) {
    if (haptic) {
      HapticFeedback.lightImpact();
    }
    // Drop any existing/queued snackbars so only the latest is shown.
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: background,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
