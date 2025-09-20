import 'package:btc_f/presentation/screens/food/food_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../../data/models/food_model.dart';

class FoodTile extends StatelessWidget {
  final Food food;

  const FoodTile({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(foodId: food.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade100,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                food.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 50),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${food.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
