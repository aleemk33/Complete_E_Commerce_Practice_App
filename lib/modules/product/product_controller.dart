import 'package:get/get.dart';
import '../../app/data/models/product_model.dart';

/// Product detail controller for selections and gallery state.
class ProductController extends GetxController {
  late Product product;
  final currentImage = 0.obs;
  final selectedSize = ''.obs;
  final selectedColor = ''.obs;

  @override
  void onInit() {
    product = Get.arguments;
    if (product.sizes.isNotEmpty) {
      selectedSize.value = product.sizes.first;
    }
    if (product.colors.isNotEmpty) {
      selectedColor.value = product.colors.first;
    }
    super.onInit();
  }
}
