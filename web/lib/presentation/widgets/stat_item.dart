import 'package:flutter/material.dart';

Widget buildStatItem(
  String title,
  String value,
  IconData icon,
  Color color,
  bool isDark,
) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF202124),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : const Color(0xFF5F6368),
        ),
      ),
    ],
  );
}
