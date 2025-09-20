import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const AppIcon({
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
