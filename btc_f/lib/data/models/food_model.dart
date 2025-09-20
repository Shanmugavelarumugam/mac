class Food {
  final int id;
  final String name;
  final double price;
  final String description;
  final List<String> tagline;
  final String cuisine;
  final double rating;
  final int timeToDelivery;
  final String imageUrl;
  final int stockQuantity;
  final int calories;
  final String spicyLevel;
  final String vegNonveg;
  final String category;
  final String? review;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.tagline,
    required this.cuisine,
    required this.rating,
    required this.timeToDelivery,
    required this.imageUrl,
    required this.stockQuantity,
    required this.calories,
    required this.spicyLevel,
    required this.vegNonveg,
    required this.category,
    this.review,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      tagline:
          (json['tagline'] as List?)?.map((e) => e.toString()).toList() ?? [],
      cuisine: json['cuisine'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      timeToDelivery: json['time_to_delivery'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      calories: json['calories'] ?? 0,
      spicyLevel: json['spicy_level'] ?? '',
      vegNonveg: json['veg_nonveg'] ?? '',
      category: json['category'] ?? '',
      review: json['review'],
    );
  }
}
