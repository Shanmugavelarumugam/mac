// models/product_model.dart
class Product {
  final int? id;
  final String name;
  final String slug;
  final String shortDescription;
  final String description;
  final String image;
  final double price;
  final int stock;
  final String sku;
  final String category;
  final String subcategory;
  final int brandId;
  final bool isAvailable;
  final bool isFeatured;
  final String createdBy;
  final List<String> tagline;
  final double discount;
  final double averageRating;

  Product({
    this.id,
    required this.name,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
    required this.sku,
    required this.category,
    required this.subcategory,
    required this.brandId,
    required this.isAvailable,
    required this.isFeatured,
    required this.createdBy,
    required this.tagline,
    required this.discount,
    required this.averageRating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    slug: json['slug'],
    shortDescription: json['shortDescription'],
    description: json['description'],
    image: json['image'],
    price: (json['price'] as num).toDouble(),
    stock: json['stock'],
    sku: json['sku'],
    category: json['category'],
    subcategory: json['subcategory'],
    brandId: json['brandId'],
    isAvailable: json['isAvailable'],
    isFeatured: json['isFeatured'],
    createdBy: json['createdBy'],
    tagline: List<String>.from(json['tagline'] ?? []),
    discount: (json['discount'] as num).toDouble(),
    averageRating: (json['averageRating'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "shortDescription": shortDescription,
    "description": description,
    "image": image,
    "price": price,
    "stock": stock,
    "sku": sku,
    "category": category,
    "subcategory": subcategory,
    "brandId": brandId,
    "isAvailable": isAvailable,
    "isFeatured": isFeatured,
    "createdBy": createdBy,
    "tagline": tagline,
    "discount": discount,
    "averageRating": averageRating,
  };
}
