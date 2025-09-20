import 'package:flutter/material.dart';

Widget buildInfoCard({
  required String title,
  required IconData icon,
  required Color iconColor,
  required String content,
  required bool isDark,
}) {
  final List<String> bulletPoints = content.split('\n');

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [Colors.grey[850]!, Colors.grey[900]!]
            : [Colors.white, Colors.grey[50]!],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: isDark ? Colors.white : Colors.grey[800],
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: 30,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.more_vert,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bulletPoints.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 12),
                    child: Icon(Icons.circle, size: 8, color: iconColor),
                  ),
                  Expanded(
                    child: Text(
                      point.replaceAll('•', '').trim(),
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Divider(color: isDark ? Colors.grey[700] : Colors.grey[300], height: 1),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
            const SizedBox(width: 6),
            Text(
              "Updated just now",
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
            const Spacer(),
            Text(
              "View more",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
