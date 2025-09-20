import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double scaleFactor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.scaleFactor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        // ✅ forces fixed height inside GridView
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // ✅ avoids overflow
            children: [
              Icon(icon, color: color, size: 20 * scaleFactor),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12 * scaleFactor,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20 * scaleFactor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
