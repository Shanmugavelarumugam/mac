import 'package:flutter/material.dart';

Widget buildProfileSection(
  String title,
  IconData icon,
  Color iconColor,
  bool isDark,
  List<Widget> items,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF202124),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D30) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE8EAED),
            width: 1,
          ),
        ),
        child: Column(children: items),
      ),
    ],
  );
}
