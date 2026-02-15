import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/data/models/product_model.dart';

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
}

/// Cart state and persistence controller.
class CartController extends GetxController {
  final box = GetStorage();
  var items = <CartItem>[].obs;

  @override
  void onInit() {
    loadCart();
    ever(items, (_) => saveCart());
    super.onInit();
  }

  void saveCart() {
    final data = items
        .map(
          (e) => {
            'id': e.product.id,
            'title': e.product.title,
            'price': e.product.price,
            'image': e.product.image,
            'category': e.product.category,
            'description': e.product.description,
            'images': e.product.images,
            'rating': e.product.rating,
            'reviews': e.product.reviews,
            'sizes': e.product.sizes,
            'colors': e.product.colors,
            'qty': e.qty,
          },
        )
        .toList();
    box.write('cart', data);
  }

  void loadCart() {
    final data = box.read('cart');
    if (data != null) {
      items.value = List<Map>.from(data).map((e) {
        return CartItem(
          product: Product(
            id: e['id'],
            title: e['title'],
            price: e['price'],
            image: e['image'],
            category: e['category'],
            description: e['description'] ?? '',
            images: List<String>.from(e['images'] ?? []),
            rating: (e['rating'] ?? 0).toDouble(),
            reviews: e['reviews'] ?? 0,
            sizes: List<String>.from(e['sizes'] ?? []),
            colors: List<String>.from(e['colors'] ?? []),
          ),
          qty: e['qty'],
        );
      }).toList();
    }
  }

  void add(Product p) {
    final index = items.indexWhere((e) => e.product.id == p.id);
    if (index >= 0) {
      items[index].qty++;
      items.refresh();
    } else {
      items.add(CartItem(product: p));
    }
  }

  void increase(CartItem item) {
    item.qty++;
    items.refresh();
  }

  void decrease(CartItem item) {
    if (item.qty > 1) {
      item.qty--;
    } else {
      items.remove(item);
    }
    items.refresh();
  }

  double get total =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.qty));

  int get itemCount => items.fold(0, (sum, item) => sum + item.qty);

  void clear() {
    items.clear();
  }
}
