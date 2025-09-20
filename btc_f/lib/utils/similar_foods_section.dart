import 'package:btc_f/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SimilarFoodsSection extends StatefulWidget {
  final int foodId;
  const SimilarFoodsSection({super.key, required this.foodId});

  @override
  State<SimilarFoodsSection> createState() => _SimilarFoodsSectionState();
}

class _SimilarFoodsSectionState extends State<SimilarFoodsSection> {
  List<dynamic> allFoods = [];
  List<dynamic> similarFoods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllFoodsAndFilter();
  }

  Future<void> loadAllFoodsAndFilter() async {
    try {
final response = await Dio().get(allFoodsApi);

      final List<dynamic> foods = response.data;

      final currentFood = foods.firstWhere(
        (food) => food['id'] == widget.foodId,
        orElse: () => null,
      );

      if (currentFood == null) {
        setState(() {
          isLoading = false;
          similarFoods = [];
        });
        return;
      }

      final List<dynamic> currentTags = currentFood['tagline'];

      final filtered =
          foods.where((food) {
            if (food['id'] == widget.foodId) return false;

            final List<dynamic> tags = food['tagline'] ?? [];
            return tags.any((tag) {
              return currentTags.any((currentTag) {
                final tagLower = tag.toString().toLowerCase().trim();
                final currentTagLower =
                    currentTag.toString().toLowerCase().trim();
                return tagLower.contains(currentTagLower) ||
                    currentTagLower.contains(tagLower);
              });
            });
          }).toList();

      setState(() {
        allFoods = foods;
        similarFoods = filtered;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading foods: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (similarFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text("No similar foods found."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "🍽️ Similar Products",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similarFoods.length,
            itemBuilder: (context, index) {
              final food = similarFoods[index];
              return GestureDetector(
                onTap: () {
                  // Navigate or show food detail
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            food['image_url'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text("₹${food['price']}"),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    food['rating'].toString(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
