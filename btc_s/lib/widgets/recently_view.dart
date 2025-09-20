import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentlyView extends StatelessWidget {
  const RecentlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3), // shift right
            child: Text(
              'Recently View',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4), // shift left
            child: Text(
              'Show all',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9B9B9B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
