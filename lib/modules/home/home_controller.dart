import 'package:get/get.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/repositories/product_repository.dart';

/// Home screen state: products, filters, and sorting.
class HomeController extends GetxController {
  final repo = ProductRepository();
  var loading = true.obs;
  var allProducts = <Product>[].obs;
  var displayedProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var sortAscending = true.obs;
  var page = 1.obs;
  var hasMore = true.obs;
  var loadingMore = false.obs;

  List<String> categories = ['All'];
  final int pageSize = 8;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void fetch() async {
    loading.value = true;
    allProducts.value = await repo.getProducts();
    final set = allProducts.map((p) => p.category).toSet().toList();
    set.sort();
    categories = ['All', ...set];
    page.value = 1;
    applyFilters();
    loading.value = false;
  }

  void applyFilters() {
    var list = allProducts.toList();

    if (selectedCategory.value != 'All') {
      list = list.where((p) => p.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    list.sort(
      (a, b) => sortAscending.value
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price),
    );

    final end = page.value * pageSize;
    displayedProducts.value = list.take(end).toList();
    hasMore.value = end < list.length;
  }

  Future<void> loadMore() async {
    if (loadingMore.value || !hasMore.value) return;
    loadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    page.value += 1;
    applyFilters();
    loadingMore.value = false;
  }
}
