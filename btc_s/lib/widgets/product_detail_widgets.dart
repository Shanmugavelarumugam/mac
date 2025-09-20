import 'package:btc_s/widgets/cart_screen.dart';
import 'package:btc_s/widgets/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class ProductDetailWidgets {
  // ✅ AppBar with Cart & Wishlist icons
  static PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Product Details', style: GoogleFonts.montserrat()),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.red),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishListScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ],
    );
  }

  // ✅ Product Detail Body
  static Widget buildProductDetailScreen({
    required BuildContext context,
    required Map<String, dynamic> product,
    required bool isWishlisted,
    required String? selectedSize,
    required int quantity,
    required Function(String?) onSizeChanged,
    required Function(int) onQuantityChanged,
    required VoidCallback onAddToCart,
    required VoidCallback onToggleWishlist,
  }) {
    final imageUrl = AppConstants.imageUrl(product['image']);
    final name = product['description'] ?? '';
    final price = '₹${product['cost']}';
    final brand = product['brand'] ?? '';
    final category = product['category'] ?? '';
    final color = product['color'] ?? '';
    final tags = (product['tags'] as List<dynamic>).join(', ');
    final details = product['details'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _buildProductInfo('Brand', brand),
          _buildProductInfo('Category', category),
          _buildProductInfo('Color', color),
          const SizedBox(height: 10),
          if (product['size'] != null && (product['size'] as List).isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedSize,
                isExpanded: true,
                underline: const SizedBox(),
                items:
                    (product['size'] as List)
                        .map<DropdownMenuItem<String>>(
                          (size) => DropdownMenuItem<String>(
                            value: size,
                            child: Text(size, style: GoogleFonts.montserrat()),
                          ),
                        )
                        .toList(),
                onChanged: onSizeChanged,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Quantity:', style: GoogleFonts.montserrat(fontSize: 14)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (quantity > 1) onQuantityChanged(quantity - 1);
                },
              ),
              Text(
                '$quantity',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  onQuantityChanged(quantity + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            details,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tags: $tags',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              letterSpacing: 1,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Bottom Bar with Add to Cart & Wishlist
  static Widget buildBottomBar(
    BuildContext context,
    bool isWishlisted,
    VoidCallback onAddToCart,
    VoidCallback onToggleWishlist,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              label: Text(
                'Add to Cart',
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onAddToCart,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: onToggleWishlist,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper for product info text
  static Widget _buildProductInfo(String label, String value) {
    return Text(
      '$label: $value',
      style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[800]),
    );
  }
}
