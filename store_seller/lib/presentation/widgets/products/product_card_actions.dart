import 'package:btc_store/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCardActions extends StatelessWidget {
  final Product product;
  final double discountedPrice;
  const ProductCardActions({
    super.key,
    required this.product,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${product.stock} in stock',
              style: TextStyle(
                color: product.stock > 10 ? Colors.green : Colors.orange,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFBBF24),
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(product.averageRating.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '₹${discountedPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        if (product.discount > 0)
          Text(
            '₹${product.price.toStringAsFixed(0)}',
            style: const TextStyle(decoration: TextDecoration.lineThrough),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildActionButton('Edit', Colors.blue, () {})),
            const SizedBox(width: 8),
            Expanded(child: _buildActionButton('Delete', Colors.red, () {})),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
