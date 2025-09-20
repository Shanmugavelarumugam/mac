import 'category_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      imageUrl:
          json['imageUrl'] ??
          'https://via.placeholder.com/150', // ✅ default image
      category:
          json['Category'] != null
              ? CategoryModel.fromJson(json['Category'])
              : CategoryModel(id: 0, name: 'Unknown'), // ✅ default category
    );
  }
}
