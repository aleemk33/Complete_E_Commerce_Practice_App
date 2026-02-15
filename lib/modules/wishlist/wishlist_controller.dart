import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/data/models/product_model.dart';

/// Wishlist state and persistence controller.
class WishlistController extends GetxController {
  final box = GetStorage();
  var items = <Product>[].obs;

  @override
  void onInit() {
    load();
    ever(items, (_) => save());
    super.onInit();
  }

  void toggle(Product p) {
    if (isSaved(p)) {
      items.removeWhere((e) => e.id == p.id);
    } else {
      items.add(p);
    }
  }

  bool isSaved(Product p) => items.any((e) => e.id == p.id);

  void save() {
    box.write(
      'wishlist',
      items
          .map(
            (e) => {
              'id': e.id,
              'title': e.title,
              'price': e.price,
              'image': e.image,
              'category': e.category,
              'description': e.description,
              'images': e.images,
              'rating': e.rating,
              'reviews': e.reviews,
              'sizes': e.sizes,
              'colors': e.colors,
            },
          )
          .toList(),
    );
  }

  void load() {
    final data = box.read('wishlist');
    if (data != null) {
      items.value = List<Map>.from(data)
          .map(
            (e) => Product(
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
          )
          .toList();
    }
  }
}
