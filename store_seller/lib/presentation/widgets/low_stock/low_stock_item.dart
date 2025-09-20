import 'package:btc_store/data/models/dashboard_model.dart';
import 'package:btc_store/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class LowStockList extends StatelessWidget {
  final List<LowStockProduct> products;
  final double scaleFactor;

  const LowStockList({
    super.key,
    required this.products,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products
          .take(3)
          .map((p) => _buildLowStockItem(context, p))
          .toList(),
    );
  }

  Widget _buildLowStockItem(BuildContext ctx, LowStockProduct product) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12 * scaleFactor),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE2E8F0).withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40 * scaleFactor,
            height: 40 * scaleFactor,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              image: product.image.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: product.image.isEmpty
                ? Icon(Iconsax.box, size: 20 * scaleFactor, color: Colors.grey)
                : null,
          ),
          SizedBox(width: 12 * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12 * scaleFactor,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.box,
                      size: 12 * scaleFactor,
                      color: const Color(0xFFFF4757),
                    ),
                    SizedBox(width: 4 * scaleFactor),
                    Text(
                      "${product.stock} left",
                      style: GoogleFonts.poppins(
                        fontSize: 11 * scaleFactor,
                        color: const Color(0xFFFF4757),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _restockButton(scaleFactor),
        ],
      ),
    );
  }

  Widget _restockButton(double scaleFactor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scaleFactor,
        vertical: 6 * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6A5AE0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "Restock",
        style: GoogleFonts.poppins(
          fontSize: 10 * scaleFactor,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
