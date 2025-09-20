import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<CreateProductEvent>((event, emit) async {
      print('Event: CreateProductEvent -> ${event.product.toJson()}');
      emit(ProductLoading());
      try {
        final product = await repository.createProduct(event.product);
        print('Product created successfully: ${product.toJson()}');
        emit(ProductOperationSuccess(product: product));
      } catch (e) {
        print('Error creating product: $e');
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      print(
        'Event: UpdateProductEvent -> productId: ${event.productId}, updates: ${event.updates}',
      );
      emit(ProductLoading());
      try {
        await repository.updateProduct(event.productId, event.updates);
        print('Product updated successfully: ${event.productId}');
        emit(ProductOperationSuccess());
      } catch (e) {
        print('Error updating product: $e');
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      print('Event: DeleteProductEvent -> productId: ${event.productId}');
      emit(ProductLoading());
      try {
        await repository.deleteProduct(event.productId);
        print('Product deleted successfully: ${event.productId}');
        emit(ProductOperationSuccess());
      } catch (e) {
        print('Error deleting product: $e');
        emit(ProductError(e.toString()));
      }
    });

    on<FetchProductsEvent>((event, emit) async {
      print('Event: FetchProductsEvent -> sellerId: ${event.sellerId}');
      emit(ProductLoading());
      try {
        final products = await repository.getProductsBySeller(event.sellerId);
        print('Products fetched: ${products.length}');
        emit(ProductLoaded(products));
      } catch (e) {
        print('Error fetching products: $e');
        emit(ProductError(e.toString()));
      }
    });
  }
}
