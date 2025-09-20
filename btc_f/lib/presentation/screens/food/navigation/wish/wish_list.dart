import 'package:btc_f/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<Map<String, dynamic>> enrichedWishes = [];
  bool isLoading = true;
  final int userId = 1;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      final response = await Dio().get(getWishlistApi(userId));

      final wishList = List<Map<String, dynamic>>.from(response.data);
      final List<Map<String, dynamic>> tempWishes = [];

      for (var wish in wishList) {
        final foodId = wish['foodId'];
        try {
          final foodRes = await Dio().get(getFoodByIdApi(foodId));

          tempWishes.add({'id': wish['id'], 'food': foodRes.data});
        } catch (e) {
          print("Failed to fetch food info for foodId: $foodId");
        }
      }

      setState(() {
        enrichedWishes = tempWishes;
        isLoading = false;
      });
    } catch (e) {
      print("Fetch wishlist failed: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteWish(int wishId) async {
    try {
      await Dio().delete(deleteWishlistItemApi(wishId));
      fetchWishlist();
    } catch (e) {
      print("Delete wish failed: $e");
    }
  }

  Future<void> clearWishlist() async {
    try {
      await Dio().delete(clearWishlistApi(userId));
      fetchWishlist();
    } catch (e) {
      print("Clear wishlist failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: "Clear All",
            onPressed: clearWishlist,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : enrichedWishes.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset("assets/empty_box.png", height: 160),
                    const SizedBox(height: 20),
                    const Text(
                      "Your wishlist is empty.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: enrichedWishes.length,
                itemBuilder: (context, index) {
                  final item = enrichedWishes[index];
                  final food = item['food'];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          food['image_url'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      title: Text(
                        food['name'] ?? 'Unnamed',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "₹${food['price']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => deleteWish(item['id']),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
