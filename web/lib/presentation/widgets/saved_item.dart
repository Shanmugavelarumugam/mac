import 'package:flutter/material.dart';
import 'package:web_app/data/model/saved_item_type.dart';
import '../utils/time_formatter.dart';

Widget buildSavedItem(
  String title,
  String description,
  String url,
  IconData icon,
  Color color,
  bool isDark,
  SavedItemType type,   // keeps track of what kind of saved item
  DateTime savedTime,   // when it was saved
  {
    List<String> tags = const [],
  }
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF2D2D30) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE8EAED),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey).withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF202124),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : const Color(0xFF5F6368),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: isDark ? Colors.white60 : const Color(0xFF5F6368),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'open', child: Text('Open')),
                const PopupMenuItem(value: 'share', child: Text('Share')),
                const PopupMenuItem(value: 'copy', child: Text('Copy link')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'remove', child: Text('Remove')),
              ],
              onSelected: (value) {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.language,
              size: 14,
              color: isDark ? Colors.white60 : const Color(0xFF5F6368),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                url.replaceAll(RegExp(r'^https?://'), ''),
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF4285F4),
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatTime(savedTime),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : const Color(0xFF5F6368),
              ),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: tags
                .take(3)
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    ),
  );
}

Widget buildGridItem(
  String title,
  String url,
  IconData icon,
  Color color,
  bool isDark,
  List<String> tags,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF2D2D30) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE8EAED),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF202124),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Text(
          url,
          style: TextStyle(fontSize: 12, color: const Color(0xFF4285F4)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          children: tags
              .take(2)
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(fontSize: 10, color: color),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}
