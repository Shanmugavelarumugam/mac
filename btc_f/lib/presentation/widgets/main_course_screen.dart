import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/food/food_bloc.dart';
import '../../../logic/food/food_state.dart';
import '../../../data/models/food_model.dart';

class MainCourseScreen extends StatelessWidget {
  const MainCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Course')),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodLoaded) {
            final mainCourses =
                state.foods.where((f) => f.category == 'main_course').toList();

            if (mainCourses.isEmpty) {
              return const Center(child: Text("No main course items found"));
            }

            return ListView.builder(
              itemCount: mainCourses.length,
              itemBuilder: (context, index) {
                final food = mainCourses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        food.imageUrl ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Icon(Icons.fastfood),
                      ),
                    ),
                    title: Text(food.name),
                    subtitle: Text("₹${food.price.toStringAsFixed(2)}"),
                  ),
                );
              },
            );
          } else if (state is FoodError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
