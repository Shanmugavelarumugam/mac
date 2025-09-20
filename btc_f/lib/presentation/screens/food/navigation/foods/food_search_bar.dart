import 'package:flutter/material.dart';

class FoodSearchBar extends StatelessWidget {
  final String query;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onCategoryChanged;

  const FoodSearchBar({
    super.key,
    required this.query,
    required this.selectedCategory,
    required this.categories,
    required this.onQueryChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (val) => onQueryChanged(val.toLowerCase()),
            decoration: InputDecoration(
              hintText: "Search food, dishes...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  query.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => onQueryChanged(''),
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  onSelected: (_) => onCategoryChanged(category),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
