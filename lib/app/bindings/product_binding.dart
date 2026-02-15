import 'package:get/get.dart';
import '../../modules/product/product_controller.dart';

/// Product detail bindings.
class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
