import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final String baseUrl = 'http://192.168.1.4:3001';
  List<dynamic> reviews = [];
  double avgRating = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final res = await Dio().get('$baseUrl/api/reviews/restaurant/1');
      final avg = await Dio().get('$baseUrl/api/reviews/restaurant/1/average');
      setState(() {
        reviews = res.data;
        avgRating = avg.data['average']?.toDouble() ?? 0.0;
      });
    } catch (e) {
      print("Review fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildReviewCard(Map review) {
    String name = review['user_name'] ?? 'User';
    String initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepOrange.shade100,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review['comment'] ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  review['rating'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAverageRating() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Text(
            avgRating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "/ 5",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("⭐ Reviews & Ratings"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchReviews,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    buildAverageRating(),
                    const SizedBox(height: 20),
                    if (reviews.isEmpty)
                      const Center(child: Text("No reviews found."))
                    else
                      ...reviews.map((r) => buildReviewCard(r)).toList(),
                  ],
                ),
              ),
    );
  }
}
