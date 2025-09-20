// bloc/product/product_state.dart
import 'package:btc_store/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);
}

class ProductOperationSuccess extends ProductState {
  final Product? product;
  const ProductOperationSuccess({this.product});
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}
