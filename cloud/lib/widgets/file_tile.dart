import 'package:cloud/widgets/file_preview_screen.dart';
import 'package:flutter/material.dart';

class FileTile extends StatelessWidget {
  final Map<String, dynamic> fileData;
  final VoidCallback? onTap;
  final VoidCallback? onStar;

  const FileTile({super.key, required this.fileData, this.onTap, this.onStar});

  @override
  Widget build(BuildContext context) {
    final String fileName = fileData['name'] ?? 'Untitled';
    final String fileType = fileData['type'] ?? 'file';
    final String size = fileData['size'] ?? '1.2 MB';
    final String date = fileData['date'] ?? 'May 25, 2025';
    final IconData icon = _getFileIcon(fileType);
    final Color color = _getFileColor(fileType);

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => FilePreviewScreen(
                      fileData: fileData,
                      icon: icon,
                      color: color,
                    ),
              ),
            );
          },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _buildContextMenu(),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: fileName,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.1),
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                fileName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '$size • $date',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'text':
        return Icons.description_rounded;
      case 'video':
        return Icons.videocam_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.redAccent;
      case 'image':
        return Colors.deepPurple;
      case 'text':
        return Colors.teal;
      case 'video':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildContextMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Star'),
            onTap: onStar, // ✅ hook into callback
          ),
          const ListTile(leading: Icon(Icons.share), title: Text('Share')),
          const ListTile(
            leading: Icon(Icons.download),
            title: Text('Download'),
          ),
          const ListTile(leading: Icon(Icons.delete), title: Text('Delete')),
        ],
      ),
    );
  }
}
