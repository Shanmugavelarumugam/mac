import 'package:btc_f/logic/food/food_bloc.dart';
import 'package:btc_f/logic/food/food_event.dart';
import 'package:btc_f/logic/food/food_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btc_f/presentation/screens/food/food_detail_screen.dart';

import 'restaurant_section.dart';

class FoodSection extends StatelessWidget {
  final String query;
  final String selectedCategory;

  const FoodSection({
    super.key,
    required this.query,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        if (state is FoodLoading) {
          return shimmerLoader();
        } else if (state is FoodLoaded) {
          final filteredFoods =
              query.isEmpty
                  ? state.foods
                  : state.foods
                      .where((f) => f.name.toLowerCase().contains(query))
                      .toList();

          return RefreshIndicator(
            onRefresh: () async {
              if (selectedCategory == 'All') {
                BlocProvider.of<FoodBloc>(context).add(LoadFoods());
              } else {
                BlocProvider.of<FoodBloc>(
                  context,
                ).add(LoadFoodsByCategory(selectedCategory));
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Foods',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = filteredFoods[index];
                        return GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FoodDetailScreen(foodId: food.id),
                                ),
                              ),
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 5),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    food.imageUrl ?? '',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.fastfood),
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${food.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const RestaurantSection(),
                ],
              ),
            ),
          );
        } else if (state is FoodError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(child: Text("Something went wrong"));
        }
      },
    );
  }
}
