import 'package:flutter/material.dart';

Widget buildQuickAction(IconData icon, String label, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.grey[700],
          height: 1.2,
        ),
      ),
    ],
  );
}
