import 'package:get/get.dart';
import 'package:btc_grocery/models/wishlist_item_model.dart';
import 'package:btc_grocery/services/api/wishlist_service.dart';
import 'package:btc_grocery/services/local/secure_storage_service.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = WishlistService();
  final SecureStorageService _storage = SecureStorageService();

  var wishlist = <WishlistItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchWishlist();
    super.onInit();
  }

  void fetchWishlist() async {
    try {
      isLoading.value = true;
      final userIdStr = await _storage.read(key: 'user_id');
      print("Fetched user_id: $userIdStr");

      final userId = int.tryParse(userIdStr ?? '');
      if (userId == null) {
        Get.snackbar('Error', 'Invalid user ID');
        return;
      }

      final items = await _wishlistService.getUserWishlist(userId);
      print("Wishlist items fetched: ${items.length}");
      wishlist.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wishlist: $e');
      print("Error in fetchWishlist: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void addToWishlist(int productId) async {
    try {
      final userIdStr = await _storage.read(key: 'user_id');
      final userId = int.tryParse(userIdStr ?? '');
      if (userId == null) return;

      await _wishlistService.addToWishlist(userId, productId);
      fetchWishlist();
      Get.snackbar('Success', 'Added to wishlist');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add');
    }
  }

  void removeFromWishlist(int wishlistItemId) async {
    try {
      await _wishlistService.removeFromWishlist(wishlistItemId);
      fetchWishlist();
      Get.snackbar('Removed', 'Item removed from wishlist');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove');
    }
  }
}
