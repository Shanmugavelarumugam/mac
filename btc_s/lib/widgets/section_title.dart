import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                'Show all',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9B9B9B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
