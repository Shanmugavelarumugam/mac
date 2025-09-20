// bloc/product/product_event.dart
import 'package:btc_store/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class CreateProductEvent extends ProductEvent {
  final Product product;
  const CreateProductEvent(this.product);
}

class UpdateProductEvent extends ProductEvent {
  final int productId;
  final Map<String, dynamic> updates;
  const UpdateProductEvent(this.productId, this.updates);
}

class DeleteProductEvent extends ProductEvent {
  final int productId;
  const DeleteProductEvent(this.productId);
}

class FetchProductsEvent extends ProductEvent {
  final int sellerId;
  const FetchProductsEvent(this.sellerId);
}
