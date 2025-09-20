import 'package:get/get.dart';
import 'package:btc_grocery/models/cart_item_model.dart';
import 'package:btc_grocery/services/api/cart_service.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;
  var total = 0.0.obs;

  final CartService _cartService = CartService();

 Future<void> loadCart(int userId) async {
    isLoading.value = true;
    try {
      final items = await _cartService.getCart(userId);
      print("🛒 Loaded ${items.length} items for user $userId");
      cartItems.assignAll(items);
      calculateTotal();
    } catch (e) {
      print("❌ Error loading cart: $e");
      Get.snackbar("Error", "Failed to load cart");
      cartItems.clear();
      total.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addItem(Map<String, dynamic> data, int userId) async {
    try {
      await _cartService.addToCart(data);
      await loadCart(userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to add item");
    }
  }

  Future<void> updateQuantity(int itemId, int quantity, int userId) async {
    try {
      await _cartService.updateCartItem(itemId, quantity);
      await loadCart(userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to update quantity");
    }
  }

  Future<void> removeItem(int itemId, int userId) async {
    try {
      await _cartService.deleteCartItem(itemId);
      await loadCart(userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to remove item");
    }
  }

  void calculateTotal() {
    total.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }
}
