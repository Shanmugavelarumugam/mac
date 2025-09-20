import 'package:btc_grocery/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import 'package:btc_grocery/models/product_model.dart';
import 'package:btc_grocery/services/api/cart_service.dart';
import 'package:btc_grocery/services/local/secure_storage_service.dart';
import 'package:btc_grocery/controllers/wishlist_controller.dart';
import 'package:btc_grocery/controllers/product_controller.dart';
import 'package:btc_grocery/controllers/review_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final cartService = CartService();
  Review? _editingReview;

  final wishlistController = Get.find<WishlistController>();
  final productController = Get.put(ProductController());
  final reviewController = Get.put(ReviewController());

  bool isWishlisted = false;
  final _commentController = TextEditingController();
  double _rating = 5;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    productController.fetchProductById(widget.productId);
    reviewController.fetchReviews(widget.productId);
    _checkIfWishlisted();
  }

  Future<void> _loadUserId() async {
    final userId = await SecureStorageService().getUserId();
    setState(() {
      _currentUserId = int.tryParse(userId ?? '');
    });
  }

  Future<void> _checkIfWishlisted() async {
    if (wishlistController.wishlist.isEmpty) {
      wishlistController.fetchWishlist();
    }
    final found = wishlistController.wishlist.any(
      (item) => item.productId == widget.productId,
    );
    setState(() {
      isWishlisted = found;
    });
  }

  Future<void> addToCart(ProductModel product) async {
    if (_currentUserId == null) {
      Get.snackbar("Error", "User not found");
      return;
    }

    final data = {
      "userId": _currentUserId,
      "productId": product.id,
      "quantity": 1,
    };

    try {
      await cartService.addToCart(data);
      Get.snackbar(
        "Success",
        "${product.name} added to cart",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add to cart",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _toggleWishlist(ProductModel product) async {
    final existingItem = wishlistController.wishlist.firstWhereOrNull(
      (item) => item.productId == product.id,
    );

    if (existingItem != null) {
      wishlistController.removeFromWishlist(existingItem.id);
      setState(() => isWishlisted = false);
    } else {
      wishlistController.addToWishlist(product.id);
      setState(() => isWishlisted = true);
    }
  }

  Future<void> _submitReview() async {
    if (_currentUserId == null) {
      Get.snackbar("Error", "User not found");
      return;
    }

    if (_editingReview != null) {
      await reviewController.updateReview(
        _editingReview!.id,
        _editingReview!.productId,
        _rating.toInt(),
        _commentController.text,
      );
      setState(() => _editingReview = null);
    } else {
      await reviewController.addReview(
        _currentUserId!,
        widget.productId,
        _rating.toInt(),
        _commentController.text,
      );
    }

    _commentController.clear();
    _rating = 5;
  }

  Widget _buildRatingStars(double rating, {Function(int)? onRate}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starFilled = index < rating.round();
        return IconButton(
          icon: Icon(
            starFilled ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onRate != null ? () => onRate(index + 1) : null,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        backgroundColor: Colors.orange,
      ),
      body: Obx(() {
        if (productController.isProductLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (productController.errorMessage.isNotEmpty) {
          return Center(child: Text(productController.errorMessage.value));
        }

        final product = productController.product.value!;
        final reviews = reviewController.reviews;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Product Info
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            onPressed: () => _toggleWishlist(product),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(product.description),
                      const SizedBox(height: 8),
                      Text(
                        "₹${product.price}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => addToCart(product),
                        child: const Text("Add to Cart"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Reviews Section
              const Text(
                "Reviews",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              reviews.isEmpty
                  ? const Text("No reviews yet.")
                  : Column(
                    children:
                        reviews.map((review) {
                          final isOwnReview = review.userId == _currentUserId;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ExpansionTile(
                              title: Text("${review.userName}"),
                              subtitle: _buildRatingStars(
                                review.rating.toDouble(),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(review.comment),
                                      if (isOwnReview)
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _editingReview = review;
                                                  _commentController.text =
                                                      review.comment;
                                                  _rating =
                                                      review.rating.toDouble();
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                reviewController.deleteReview(
                                                  review.id,
                                                  widget.productId,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),

              const Divider(height: 32),

              // Add Review
              const Text(
                "Leave a review",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: "Comment"),
              ),
              const SizedBox(height: 8),
              _buildRatingStars(
                _rating,
                onRate: (rate) {
                  setState(() {
                    _rating = rate.toDouble();
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text(
                  _editingReview != null ? "Update Review" : "Submit Review",
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
