class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final Product product;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      productId: json['productId'] ?? 0,
      product: Product.fromJson(json['Product'] ?? {}),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      price: (json['price'] != null ? (json['price'] as num).toDouble() : 0.0),
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
