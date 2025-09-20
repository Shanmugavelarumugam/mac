import 'package:flutter/material.dart';

Widget buildCategoryChip(String label, IconData icon, int count, bool isDark) {
  return Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE8EAED),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFD1D5DB),
        width: 0.5,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white70 : const Color(0xFF5F6368),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF202124),
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : const Color(0xFF5F6368),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
