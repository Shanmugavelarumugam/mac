import 'package:flutter/material.dart';

class FilePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> fileData;
  final IconData icon;
  final Color color;

  const FilePreviewScreen({super.key, 
    required this.fileData,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = fileData['name'];
    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: Center(
        child: Hero(
          tag: fileName,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, size: 100, color: color),
          ),
        ),
      ),
    );
  }
}
