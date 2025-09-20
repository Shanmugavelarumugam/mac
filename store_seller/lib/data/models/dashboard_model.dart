class LowStockProduct {
  final int id;
  final String name;
  final String slug;
  final String shortDescription;
  final String description;
  final String image;
  final double price;
  final int stock;

  LowStockProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
  });

  factory LowStockProduct.fromJson(Map<String, dynamic> json) {
    return LowStockProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
    );
  }
}

class OrderStatusCount {
  final String status;
  final int count;

  OrderStatusCount({required this.status, required this.count});

  factory OrderStatusCount.fromJson(Map<String, dynamic> json) {
    return OrderStatusCount(
      status: json['status'] ?? 'Pending',
      count: int.tryParse(json['count'].toString()) ?? 0,
    );
  }
}

class MonthlyStat {
  final String date;
  final int totalSold; // <-- match backend key

  MonthlyStat({required this.date, required this.totalSold});

  factory MonthlyStat.fromJson(Map<String, dynamic> json) {
    return MonthlyStat(
      date: json['date'] ?? '',
      totalSold: int.tryParse(json['totalSold'].toString()) ?? 0,
    );
  }
}
