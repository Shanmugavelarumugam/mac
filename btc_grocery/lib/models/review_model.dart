class Review {
  final int id;
  final int userId;
  final int productId;
  final int rating;
  final String comment;
  final String userName;

  Review({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      rating: json['rating'],
      comment: json['comment'],
      userName: json['User']?['name'] ?? 'Anonymous',
    );
  }
}
