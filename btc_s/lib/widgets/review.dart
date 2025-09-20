import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ReviewSection extends StatefulWidget {
  final Map<String, dynamic> product;
  const ReviewSection({super.key, required this.product});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  double? averageRating;
  List<Map<String, dynamic>> reviews = [];
  TextEditingController reviewController = TextEditingController();
  int currentUserId = 2; // Replace with actual user ID
  double selectedRating = 4;

  @override
  void initState() {
    super.initState();
    fetchReviewsAndRating();
  }

  Future<void> fetchReviewsAndRating() async {
    final pid = widget.product['id'];
    try {
      final reviewRes = await http.get(
        Uri.parse('http://localhost:3001/api/reviews/$pid'),
      );
      if (reviewRes.statusCode == 200) {
        final List decoded = jsonDecode(reviewRes.body);
        reviews = decoded.cast<Map<String, dynamic>>();
      }

      final avgRes = await http.get(
        Uri.parse('http://localhost:3001/api/reviews/$pid/average-rating'),
      );
      if (avgRes.statusCode == 200) {
        final decoded = jsonDecode(avgRes.body);
        averageRating = decoded['averageRating']?.toDouble();
      }
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    }
  }

  Future<void> postReview() async {
    final pid = widget.product['id'];
    final url = Uri.parse('http://localhost:3001/api/reviews');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pid': pid,
        'uid': currentUserId,
        'reviewText': reviewController.text.trim(),
        'rating': selectedRating,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      reviewController.clear();
      fetchReviewsAndRating();
    }
  }

  Future<void> postReply(int reviewId, String replyText) async {
    final pid = widget.product['id'];
    final url = Uri.parse('http://localhost:3001/api/reviews/reply');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pid': pid,
        'uid': currentUserId,
        'reviewId': reviewId,
        'replyText': replyText,
      }),
    );
    fetchReviewsAndRating();
  }

  Widget buildReviewCard(Map<String, dynamic> review) {
    final replyController = TextEditingController();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review['reviewText'] ?? '',
              style: GoogleFonts.montserrat(fontSize: 15),
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < (review['rating'] ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                  size: 20,
                  color: Colors.orange,
                );
              }),
            ),
            const SizedBox(height: 10),
            if (review['replies'] != null && review['replies'].isNotEmpty) ...[
              const Divider(),
              Text(
                'Replies:',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
              ),
              ...List.generate(
                review['replies'].length,
                (i) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '👤 ${review['replies'][i]['replyText']}',
                    style: GoogleFonts.montserrat(fontSize: 14),
                  ),
                ),
              ),
            ],
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed:
                      () =>
                          postReply(review['id'], replyController.text.trim()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (averageRating != null)
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < averageRating!.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$averageRating / 5.0',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ],
            ),
          const SizedBox(height: 20),
          TextField(
            controller: reviewController,
            decoration: InputDecoration(
              hintText: 'Write your review...',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Rating:', style: GoogleFonts.montserrat()),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                    ),
                    iconSize: 28,
                    onPressed: () {
                      setState(() {
                        selectedRating = starIndex.toDouble();
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: postReview,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...reviews.map(buildReviewCard).toList(),
        ],
      ),
    );
  }
}
