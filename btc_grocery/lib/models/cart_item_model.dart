class CartItem {
  final int id;
  final int productId;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['Product'] ?? {};

    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: product['name'] ?? 'Unknown Product',
      imageUrl: product['imageUrl'] ?? '',
      price: double.tryParse(product['price'].toString()) ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "name": name,
      "imageUrl": imageUrl,
      "price": price,
      "quantity": quantity,
    };
  }
}
