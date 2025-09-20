import 'package:flutter/material.dart';
import 'package:btc_grocery/models/product_model.dart';
import 'package:btc_grocery/views/products/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.orange.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(2, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                product.imageUrl,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
              ),
            ),

            const SizedBox(height: 10),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            // Product Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${product.price.toStringAsFixed(0)} ₹',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
