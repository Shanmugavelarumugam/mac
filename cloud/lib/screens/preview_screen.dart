import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String fileName;
  final String fileType;
  final String heroTag;

  const PreviewScreen({
    required this.fileName,
    required this.fileType,
    required this.heroTag,
  });

  IconData _getIcon() {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'text':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColor() {
    switch (fileType) {
      case 'pdf':
        return Colors.redAccent;
      case 'image':
        return Colors.green;
      case 'text':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();
    final color = _getColor();

    return Scaffold(
      appBar: AppBar(title: Text("Preview")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: heroTag,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 64, color: color),
              ),
            ),
            SizedBox(height: 20),
            Text(
              fileName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(fileType.toUpperCase(), style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
