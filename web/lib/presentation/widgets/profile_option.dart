import 'package:flutter/material.dart';

Widget buildProfileOption(
  String title,
  String subtitle,
  IconData icon,
  VoidCallback onTap,
  bool isDark,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D30) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE8EAED),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4285F4), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF202124),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : const Color(0xFF5F6368),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white60 : const Color(0xFF5F6368),
            size: 20,
          ),
        ],
      ),
    ),
  );
}
