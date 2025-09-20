import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final String imagePath;
  final double size;

  const AppIcon({required this.imagePath, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
