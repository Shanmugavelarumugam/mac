import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/controllers/cart_controller.dart';
import 'package:btc_grocery/services/local/secure_storage_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndCart();
  }

  Future<void> _loadUserIdAndCart() async {
    final userIdStr = await SecureStorageService().getUserId();
    if (userIdStr != null) {
      userId = int.tryParse(userIdStr);
      if (userId != null) {
        await cartController.loadCart(userId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text("Your cart is empty", style: TextStyle(fontSize: 18)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          item.imageUrl.isNotEmpty
                              ? Image.network(
                                item.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(Icons.image),
                              )
                              : const Icon(Icons.image_not_supported, size: 60),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₹${item.price} x ${item.quantity}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity > 1 && userId != null) {
                                    cartController.updateQuantity(
                                      item.id,
                                      item.quantity - 1,
                                      userId!,
                                    );
                                  }
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  if (userId != null) {
                                    cartController.updateQuantity(
                                      item.id,
                                      item.quantity + 1,
                                      userId!,
                                    );
                                  }
                                },
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  if (userId != null) {
                                    cartController.removeItem(item.id, userId!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ₹${cartController.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Get.snackbar("Checkout", "Proceeding to checkout...");
                  // TODO: Implement actual checkout logic
                },
                child: const Text("Checkout", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
