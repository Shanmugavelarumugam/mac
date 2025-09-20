import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final double scaleFactor;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Iconsax.home, "Dashboard", 0),
          _buildNavItem(Iconsax.box, "Products", 1),
          _buildNavItem(Iconsax.shopping_bag, "Orders", 2),
          _buildNavItem(Iconsax.dollar_circle, "Earnings", 3),
          _buildNavItem(Iconsax.user, "Profile", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    final color = isSelected
        ? const Color(0xFF6A5AE0)
        : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70 * scaleFactor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 42 * scaleFactor,
                height: 42 * scaleFactor,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF9087E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A5AE0).withOpacity(0.4),
                      blurRadius: 6 * scaleFactor,
                      offset: Offset(0, 3 * scaleFactor),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22 * scaleFactor, color: Colors.white),
              )
            else
              Icon(icon, size: 22 * scaleFactor, color: color),
            SizedBox(height: 4 * scaleFactor),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10 * scaleFactor,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
