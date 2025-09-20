import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/controllers/wishlist_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController controller = Get.find<WishlistController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlist.isEmpty) {
          return const Center(child: Text('No items in wishlist'));
        }

        return ListView.builder(
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final item = controller.wishlist[index];

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading:
                    item.product.imageUrl.isNotEmpty
                        ? Image.network(
                          item.product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image),
                title: Text(item.product.name),
                subtitle: Text('₹${item.product.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeFromWishlist(item.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
