// Keep your existing imports
import 'package:btc_f/utils/constants.dart';
import 'package:btc_f/utils/similar_foods_section.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FoodDetailScreen extends StatefulWidget {
  final int foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Map<String, dynamic>? food;
  Map<int, dynamic> userCache = {};
  bool isLoading = true;
  int quantity = 1;
  final int userId = 1;
  List<dynamic> reviews = [];
  final TextEditingController _commentController = TextEditingController();
  double _rating = 4.0;

  @override
  void initState() {
    super.initState();
    fetchFoodById();
    fetchReviews();
  }

  Future<void> fetchFoodById() async {
    try {
      final response = await Dio().get(foodWithRatingApi(widget.foodId));
      setState(() {
        food = response.data['food'];
        food!['avgRating'] = response.data['avgRating'];
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchUserById(int userId) async {
    if (userCache.containsKey(userId)) return;

    try {
   final response = await Dio().get(getUserByIdApi(userId));


      // Extract 'user' object if wrapped
      final user =
          response.data is Map && response.data.containsKey('user')
              ? response.data['user']
              : response.data;

      userCache[userId] = user;
      setState(() {}); // Refresh UI
    } catch (e) {
      print("Failed to fetch user $userId: $e");
      userCache[userId] = {"name": "User $userId"}; // fallback
    }
  }

  Future<void> fetchReviews() async {
    try {
    final response = await Dio().get(reviewsByFoodIdApi(widget.foodId));

      final reversed = List.from(response.data.reversed);

      for (var review in reversed) {
        await fetchUserById(review['userId']);
      }

      setState(() {
        reviews = reversed;
      });
    } catch (e) {
      print("Fetch reviews error: $e");
    }
  }

  Future<void> addReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please write a comment")));
      return;
    }
    try {
      await Dio().post(
        postReviewApi,
        data: {
          "userId": userId,
          "foodId": widget.foodId,
          "rating": _rating,
          "comment": _commentController.text.trim(),
        },
      );

      _commentController.clear();
      await fetchReviews();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Review added")));
    } catch (e) {
      print("Review failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Failed to add review")));
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
await Dio().delete(deleteReviewApi(reviewId));
      await fetchReviews();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("🗑️ Review deleted")));
    } catch (e) {
      print("Delete failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to delete review")),
      );
    }
  }

  Future<void> addToCart() async {
    try {
   await Dio().post(
        postCartApi,
        data: {"userId": userId, "foodId": widget.foodId, "quantity": quantity},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Added to cart!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Add to cart failed: $e");
    }
  }

  Future<void> addToWishlist() async {
    try {
      await Dio().post(
        postWishApi,
        data: {"userId": userId, "foodId": widget.foodId},
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("💖 Added to wishlist!")));
    } catch (e) {
      print("Wishlist failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: addToWishlist,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : food == null
              ? const Center(child: Text("Food not found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        food!['image_url'] ?? '',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name, Rating, Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              food!['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  double.tryParse(
                                        food!['avgRating'].toString(),
                                      )?.toStringAsFixed(1) ??
                                      '0.0',
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '₹${food!['price']}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(food!['description'] ?? ''),
                    const Divider(height: 32),

                    // Info chips
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        InfoChip(label: "Cuisine", value: food!['cuisine']),
                        InfoChip(
                          label: "Rating",
                          value: "${food!['avgRating']}",
                        ),
                        InfoChip(label: "Spicy", value: food!['spicy_level']),
                        InfoChip(label: "Type", value: food!['veg_nonveg']),
                        InfoChip(
                          label: "Calories",
                          value: "${food!['calories']} kcal",
                        ),
                        InfoChip(
                          label: "Delivery",
                          value: "${food!['time_to_delivery']} min",
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Quantity:", style: TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (quantity > 1) setState(() => quantity--);
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => setState(() => quantity++),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    // Review input
                    const Text(
                      "📝 Add Review",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Rating: "),
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                          ),
                          itemBuilder:
                              (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            setState(() => _rating = rating);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write your review...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: addReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: const Text("Submit Review"),
                    ),

                    const Divider(height: 32),

                    // Reviews
                    const Text(
                      "📢 Reviews",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    reviews.isEmpty
                        ? const Text("No reviews yet. Be the first to review!")
                        : Column(
                          children:
                              reviews.map((review) {
                                final userName =
                                    userCache[review['userId']]?['name'] ??
                                    "User ${review['userId']}";
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Row(
                                      children: [
                                        Text("⭐ ${review['rating']}"),
                                        const SizedBox(width: 10),
                                        Text(userName),
                                      ],
                                    ),
                                    subtitle: Text(review['comment']),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('dd MMM').format(
                                            DateTime.parse(review['createdAt']),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        if (review['userId'] == userId)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            tooltip: 'Delete Review',
                                            onPressed: () async {
                                              final confirmed = await showDialog<
                                                bool
                                              >(
                                                context: context,
                                                builder:
                                                    (_) => AlertDialog(
                                                      title: const Text(
                                                        "Delete Review?",
                                                      ),
                                                      content: const Text(
                                                        "Are you sure you want to delete this review?",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                    false,
                                                                  ),
                                                          child: const Text(
                                                            "Cancel",
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                    true,
                                                                  ),
                                                          child: const Text(
                                                            "Delete",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                              if (confirmed == true) {
                                                deleteReview(review['id']);
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),

                    const Divider(height: 32),
                    SimilarFoodsSection(foodId: widget.foodId),
                  ],
                ),
              ),
      bottomNavigationBar:
          food != null
              ? Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: addToCart,
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.flash_on),
                        label: const Text('Buy Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}

class InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const InfoChip({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.orange[50],
      side: const BorderSide(color: Colors.deepOrange),
    );
  }
}
