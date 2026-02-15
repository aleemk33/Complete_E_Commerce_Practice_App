import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/auth/auth_controller.dart';
import 'app_routes.dart';

/// Prevents authenticated users from visiting guest-only routes.
class GuestOnlyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.profile);
    }
    return null;
  }
}
