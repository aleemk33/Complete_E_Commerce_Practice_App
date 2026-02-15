class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  final List<String> images;
  final double rating;
  final int reviews;
  final List<String> sizes;
  final List<String> colors;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    this.description = '',
    this.images = const [],
    this.rating = 0,
    this.reviews = 0,
    this.sizes = const [],
    this.colors = const [],
  });
}
