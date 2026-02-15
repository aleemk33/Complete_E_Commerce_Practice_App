import '../models/product_model.dart';
import '../services/api_service.dart';

/// Repository for product data.
class ProductRepository {
  final ApiService apiService = ApiService();

  Future<List<Product>> getProducts() => apiService.fetchProducts();
}
