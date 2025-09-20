import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onDelete;
  final Function(int, int) onUpdateQuantity;

  const CartTile({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final food = item['food'];
    final quantity = item['quantity'];
    final cartItemId = item['cartItemId'];
    final price =
        (double.tryParse(food['price']?.toString() ?? '0') ?? 0) * quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            (food['image_url']?.isNotEmpty ?? false)
                ? food['image_url']
                : 'https://via.placeholder.com/60',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
          ),
        ),
        title: Text(
          food['name'] ?? 'Unnamed Food',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed:
                    quantity > 1
                        ? () => onUpdateQuantity(cartItemId, quantity - 1)
                        : null,
              ),
              Text(
                "Qty: $quantity",
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onUpdateQuantity(cartItemId, quantity + 1),
              ),
            ],
          ),
        ),
        trailing: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.grey),
                onPressed: () => onDelete(cartItemId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
