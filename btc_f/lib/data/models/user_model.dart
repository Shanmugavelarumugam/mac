class User {
  final String name;
  final String email;
  final String token;

  User({required this.name, required this.email, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return User(name: user['name'], email: user['email'], token: json['token']);
  }

  get id => null;
}
