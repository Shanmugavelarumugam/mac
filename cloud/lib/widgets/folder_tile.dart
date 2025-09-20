import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final String folderName;
  final int itemCount;
  final Color color;

  const FolderTile({
    super.key,
    required this.folderName,
    required this.itemCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // TODO: navigate to folder
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_rounded, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              folderName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              '$itemCount items',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
