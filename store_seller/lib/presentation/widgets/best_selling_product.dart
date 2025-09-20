import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class BestSellingProductCard extends StatelessWidget {
  final String bestSellingProduct;
  final double scaleFactor;

  const BestSellingProductCard({
    super.key,
    required this.bestSellingProduct,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50 * scaleFactor,
            height: 50 * scaleFactor,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFFCC80)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Iconsax.crown1,
              size: 24 * scaleFactor,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12 * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Best Seller",
                  style: GoogleFonts.poppins(
                    fontSize: 12 * scaleFactor,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Text(
                  bestSellingProduct,
                  style: GoogleFonts.poppins(
                    fontSize: 14 * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Iconsax.arrow_right_3,
            size: 20 * scaleFactor,
            color: const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }
}
