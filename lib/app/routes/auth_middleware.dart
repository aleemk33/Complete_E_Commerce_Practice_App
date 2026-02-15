import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/auth/auth_controller.dart';
import 'app_routes.dart';

/// Guards private routes and redirects to login when needed.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    if (!auth.isLoggedIn) {
      auth.setPendingRoute(route);
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
