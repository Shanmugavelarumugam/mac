class Brand {
  final int id;
  final String name;
  final String slug;
  final String logo;
  final String description;
  final bool isFeatured;
  final int sellerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
    required this.description,
    required this.isFeatured,
    required this.sellerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      slug: json['slug'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      sellerId: json['sellerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "logo": logo,
      "isFeatured": isFeatured,
      "description": description,
    };
  }
}
