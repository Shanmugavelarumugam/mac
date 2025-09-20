// TODO Implement this library.
import 'package:flutter/material.dart';

class BannerCarousel extends StatelessWidget {
  final List<String> images = [
    'https://via.placeholder.com/400x150',
    'https://via.placeholder.com/400x150',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (_, i) => Image.network(images[i], fit: BoxFit.cover),
      ),
    );
  }
}
