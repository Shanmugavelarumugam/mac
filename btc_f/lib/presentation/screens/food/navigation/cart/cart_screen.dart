import 'package:btc_f/presentation/widgets/cart_tile.dart';
import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';
import 'cart_bottom_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final int userId = 1;
  final Dio dio = Dio();
  List<Map<String, dynamic>> cartWithDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    setState(() => isLoading = true);
    try {
    final cartResponse = await dio.get(getCartApi(userId));

      final cartItems = cartResponse.data;
      List<Map<String, dynamic>> tempList = [];

      for (var item in cartItems) {
        final foodRes = await dio.get(getFoodByIdApi(item['foodId']));

        tempList.add({
          'cartItemId': item['id'],
          'food': foodRes.data,
          'foodId': item['foodId'],
          'quantity': item['quantity'],
        });
      }

      setState(() {
        cartWithDetails = tempList;
        isLoading = false;
      });
    } catch (e) {
      print("Cart Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> clearCart() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Clear Cart?'),
            content: const Text(
              'Do you really want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
    if (confirm != true) return;

    try {
await dio.delete(clearCartApi(userId));
      setState(() => cartWithDetails = []);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("🧹 Cart cleared")));
    } catch (e) {
      print("Clear Cart Error: $e");
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    try {
await dio.delete(deleteCartItemApi(cartItemId));
      fetchCartItems();
    } catch (e) {
      print('Remove item error: $e');
    }
  }

  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    final index = cartWithDetails.indexWhere(
      (item) => item['cartItemId'] == cartItemId,
    );
    if (index == -1 || cartWithDetails[index]['quantity'] == newQuantity)
      return;

    try {
      await dio.put(
        updateCartItemApi(cartItemId),
        data: {'userId': userId, 'quantity': newQuantity},
      );

      setState(() {
        cartWithDetails[index]['quantity'] = newQuantity;
      });
    } catch (e) {
      print('Update Error: $e');
    }
  }

  double get totalAmount {
    return cartWithDetails.fold(0, (sum, item) {
      final price =
          double.tryParse(item['food']['price']?.toString() ?? '0') ?? 0;
      final quantity = item['quantity'] ?? 0;
      return sum + (price * quantity);
    });
  }

  Widget buildShimmerCard() => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: Container(width: 60, height: 60, color: Colors.white),
        title: Container(height: 16, color: Colors.white),
        subtitle: Container(height: 12, color: Colors.white),
        trailing: Container(height: 16, width: 50, color: Colors.white),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛒 My Cart"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: cartWithDetails.isEmpty ? null : clearCart,
            tooltip: "Clear Cart",
          ),
        ],
      ),
      body:
          isLoading
              ? ListView.builder(
                itemCount: 5,
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, __) => buildShimmerCard(),
              )
              : cartWithDetails.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 72,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text("Your cart is empty", style: TextStyle(fontSize: 16)),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: cartWithDetails.length,
                itemBuilder:
                    (context, index) => CartTile(
                      item: cartWithDetails[index],
                      onDelete: removeCartItem,
                      onUpdateQuantity: updateQuantity,
                    ),
              ),
      bottomNavigationBar:
          cartWithDetails.isNotEmpty
              ? CartBottomBar(totalAmount: totalAmount)
              : null,
    );
  }
}
