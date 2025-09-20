import 'package:btc_f/utils/constants.dart';
import 'package:dio/dio.dart';
import '../models/food_model.dart';

class FoodRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<Food>> fetchAllFoods() async {
    final response = await dio.get(allFoodsApi);
    return (response.data as List).map((json) => Food.fromJson(json)).toList();
  }

  Future<List<Food>> getFoodsByCategory(String category) async {
    final response = await dio.get(foodByCategoryApi(category));
    return (response.data as List).map((json) => Food.fromJson(json)).toList();
  }

  Future<void> deleteFood(int id) async {
    await dio.delete(deleteFoodApi(id));
  }
}
