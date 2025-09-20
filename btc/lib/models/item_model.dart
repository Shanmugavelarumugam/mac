class Item {
  final int id;
  final String name;
  final String? sku;
  final String? category;
  final String? description;
  final int quantity;
  final double? unitCost;
  final int? reorderLevel;

  Item({
    required this.id,
    required this.name,
    this.sku,
    this.category,
    this.description,
    required this.quantity,
    this.unitCost,
    this.reorderLevel,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'] ?? '',
      sku: json['sku'],
      category: json['category'],
      description: json['description'],
      quantity: json['quantity'] ?? 0,
      unitCost:
          json['unitCost'] != null
              ? (json['unitCost'] as num).toDouble()
              : null,
      reorderLevel:
          json['reorderLevel'] != null
              ? (json['reorderLevel'] as num).toInt()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'category': category,
      'description': description,
      'quantity': quantity,
      'unitCost': unitCost,
      'reorderLevel': reorderLevel,
    };
  }
}
