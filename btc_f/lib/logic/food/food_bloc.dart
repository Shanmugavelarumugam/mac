import 'package:flutter_bloc/flutter_bloc.dart';
import 'food_event.dart';
import 'food_state.dart';
import '../../data/repositories/food_repository.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;
  FoodBloc(this.repository) : super(FoodInitial()) {
    on<LoadFoods>(_onLoadFoods);
    on<DeleteFood>(_onDeleteFood);
    on<LoadFoodsByCategory>(_onLoadFoodsByCategory);
  }

  void _onLoadFoods(LoadFoods event, Emitter<FoodState> emit) async {
    emit(FoodLoading());
    try {
      final foods = await repository.fetchAllFoods();
      emit(FoodLoaded(foods));
    } catch (e) {
      emit(FoodError('Failed to load food list'));
    }
  }

  void _onDeleteFood(DeleteFood event, Emitter<FoodState> emit) async {
    try {
      await repository.deleteFood(event.foodId);
      add(LoadFoods());
    } catch (e) {
      emit(FoodError('Failed to delete food'));
    }
  }

  void _onLoadFoodsByCategory(
    LoadFoodsByCategory event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());
    try {
      final foods = await repository.getFoodsByCategory(event.category);
      emit(FoodLoaded(foods));
    } catch (e) {
      emit(FoodError("Failed to load category: ${event.category}"));
    }
  }
}
