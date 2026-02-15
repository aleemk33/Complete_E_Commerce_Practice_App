import 'package:get/get.dart';
import '../../modules/home/home_view.dart';
import '../../modules/settings/settings_view.dart';
import '../../modules/product/product_view.dart';
import '../../modules/cart/cart_view.dart';
import '../../modules/wishlist/wishlist_view.dart';
import '../../modules/checkout/checkout_view.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/auth/login_view.dart';
import '../../modules/auth/signup_view.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/orders/orders_view.dart';
import '../../modules/addresses/address_list_view.dart';
import 'auth_middleware.dart';
import 'app_routes.dart';
import '../bindings/home_binding.dart';
import '../bindings/product_binding.dart';
import '../bindings/checkout_binding.dart';
import '../bindings/orders_binding.dart';
import '../bindings/addresses_binding.dart';
import 'guest_middleware.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView()),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(name: AppRoutes.settings, page: () => SettingsView()),
    GetPage(
      name: AppRoutes.product,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(name: AppRoutes.cart, page: () => CartView()),
    GetPage(name: AppRoutes.wishlist, page: () => WishlistView()),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      middlewares: [GuestOnlyMiddleware()],
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      middlewares: [GuestOnlyMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => OrdersView(),
      binding: OrdersBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addresses,
      page: () => AddressListView(),
      binding: AddressesBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
