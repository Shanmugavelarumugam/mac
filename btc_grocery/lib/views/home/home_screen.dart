import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/controllers/auth_controller.dart';
import 'package:btc_grocery/controllers/home_controller.dart';
import 'package:btc_grocery/widgets/category_card.dart';
import 'package:btc_grocery/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Obx(() {
          final name = authController.userName.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Text(
                name.isNotEmpty ? '$name 👋' : 'Guest 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Get.toNamed('/wishlist'), // ✅ Navigate to wishlist
            color: Colors.black87,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.toNamed('/cart'),
            color: Colors.black87,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                content: const Text('Are you sure you want to logout?'),
                textConfirm: 'Yes',
                textCancel: 'No',
                confirmTextColor: Colors.white,
                onConfirm: authController.logout,
              );
            },
            color: Colors.black87,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAllData,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildCategorySection(controller),
                const SizedBox(height: 24),
                _buildPopularItems(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed('/search'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              'Search groceries...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shop by Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child:
              controller.categories.isEmpty
                  ? const Center(child: Text('No categories found.'))
                  : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      return CategoryCard(
                        category: controller.categories[index],
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildPopularItems(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Items',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        controller.products.isEmpty
            ? const Center(child: Text('No popular items available.'))
            : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder:
                  (_, index) =>
                      ProductCard(product: controller.products[index]),
            ),
      ],
    );
  }
}
