import 'package:get/get.dart';
import '../../models/review_model.dart';
import '../../services/api/review_service.dart';

class ReviewController extends GetxController {
  final reviews = <Review>[].obs;
  final _service = ReviewService();

  Future<void> fetchReviews(int productId) async {
    try {
      final result = await _service.fetchReviews(productId);
      reviews.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch reviews: $e");
    }
  }

  Future<void> addReview(
    int userId,
    int productId,
    int rating,
    String comment,
  ) async {
    try {
      await _service.addReview(
        userId: userId,
        productId: productId,
        rating: rating,
        comment: comment,
      );
      fetchReviews(productId);
      Get.snackbar("Success", "Review added");
    } catch (e) {
      Get.snackbar("Error", "Could not add review: $e");
    }
  }

  Future<void> updateReview(
    int reviewId,
    int productId,
    int rating,
    String comment,
  ) async {
    try {
      await _service.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
      fetchReviews(productId);
      Get.snackbar("Success", "Review updated");
    } catch (e) {
      Get.snackbar("Error", "Could not update review: $e");
    }
  }

  Future<void> deleteReview(int reviewId, int productId) async {
    try {
      await _service.deleteReview(reviewId);
      fetchReviews(productId);
      Get.snackbar("Success", "Review deleted");
    } catch (e) {
      print("Delete review error: $e");

      Get.snackbar("Error", "Could not delete review: ${e.toString()}");
    }
  }
}
