class OrderItem {
  final String title;
  final double price;
  final int qty;

  OrderItem({required this.title, required this.price, required this.qty});

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'qty': qty,
      };

  factory OrderItem.fromJson(Map data) => OrderItem(
        title: data['title'],
        price: (data['price'] ?? 0).toDouble(),
        qty: data['qty'] ?? 1,
      );
}

class Order {
  final String id;
  final DateTime placedAt;
  final String address;
  final String status;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.placedAt,
    required this.address,
    required this.status,
    required this.total,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'placedAt': placedAt.toIso8601String(),
        'address': address,
        'status': status,
        'total': total,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory Order.fromJson(Map data) => Order(
        id: data['id'],
        placedAt: DateTime.parse(data['placedAt']),
        address: data['address'],
        status: data['status'],
        total: (data['total'] ?? 0).toDouble(),
        items: List<Map>.from(data['items'] ?? [])
            .map((e) => OrderItem.fromJson(e))
            .toList(),
      );
}
