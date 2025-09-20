abstract class FoodEvent {}

class LoadFoods extends FoodEvent {}

class DeleteFood extends FoodEvent {
  final int foodId;
  DeleteFood(this.foodId);
}

class LoadFoodsByCategory extends FoodEvent {
  final String category;
  LoadFoodsByCategory(this.category);
}
