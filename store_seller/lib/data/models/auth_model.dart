class Seller {
  final int id;
  final String name;
  final String email;
  final String? phone;

  Seller({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class AuthResponse {
  final String? token;
  final Seller? seller;
  final String message;

  AuthResponse({this.token, this.seller, required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
      message: json['message'],
    );
  }
}
