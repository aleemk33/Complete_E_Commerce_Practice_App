import 'package:get/get.dart';
import '../../modules/auth/auth_controller.dart';
import '../../modules/cart/cart_controller.dart';
import '../../modules/wishlist/wishlist_controller.dart';
import '../theme/app_theme.dart';

/// Registers app-wide dependencies.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
  }
}
