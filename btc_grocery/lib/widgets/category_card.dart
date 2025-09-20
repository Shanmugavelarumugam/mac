import 'package:flutter/material.dart';
import 'package:btc_grocery/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
