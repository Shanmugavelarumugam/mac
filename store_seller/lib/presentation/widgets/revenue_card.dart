import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueCard extends StatelessWidget {
  final double scaleFactor;
  final int revenue;

  const RevenueCard({
    super.key,
    required this.scaleFactor,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Format revenue in Indian style
    final revenueFormat = NumberFormat.currency(
      locale: 'en_IN', // Indian numbering system
      symbol: '₹',
      decimalDigits: 0, // No decimals for totals
    );

    return SizedBox(
      height: 140 * scaleFactor,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8 * scaleFactor,
                vertical: 4 * scaleFactor,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF6A5AE0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Revenue (Total)", // ✅ Changed label
                style: TextStyle(
                  fontSize: 12 * scaleFactor,
                  color: const Color(0xFF6A5AE0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Revenue Value
            Text(
              revenueFormat.format(revenue), // ✅ Formatted Indian currency
              style: TextStyle(
                fontSize: 20 * scaleFactor,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
