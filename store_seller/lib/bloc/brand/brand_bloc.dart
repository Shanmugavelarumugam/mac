import 'package:btc_store/data/repositories/brand_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'brand_event.dart';
import 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository repository;

  BrandBloc({required this.repository}) : super(BrandInitial()) {
    on<CreateBrandEvent>((event, emit) async {
      print("CreateBrandEvent triggered with: ${event.brand.toJson()}");
      emit(BrandLoading());
      try {
        final brand = await repository.createBrand(event.brand);
        print("Brand created successfully: ${brand.toJson()}");
        emit(BrandSuccess(brand));
      } catch (e) {
        print("Brand creation failed: $e");
        emit(BrandFailure(e.toString()));
      }
    });

    on<UpdateBrandEvent>((event, emit) async {
      print(
        "UpdateBrandEvent triggered for id: ${event.id} with updates: ${event.updates}",
      );
      emit(BrandLoading());
      try {
        final brand = await repository.updateBrand(event.id, event.updates);
        print("Brand updated successfully: ${brand.toJson()}");
        emit(BrandSuccess(brand));
      } catch (e) {
        print("Brand update failed: $e");
        emit(BrandFailure(e.toString()));
      }
    });

    on<DeleteBrandEvent>((event, emit) async {
      print("DeleteBrandEvent triggered for id: ${event.id}");
      emit(BrandLoading());
      try {
        await repository.deleteBrand(event.id);
        print("Brand deleted successfully: ${event.id}");
        emit(BrandDeleted());
      } catch (e) {
        print("Brand deletion failed: $e");
        emit(BrandFailure(e.toString()));
      }
    });
    on<FetchBrandsBySellerEvent>((event, emit) async {
      print(
        "FetchBrandsBySellerEvent triggered for sellerId: ${event.sellerId}",
      );
      emit(BrandLoading());
      try {
        final brands = await repository.getBrandsBySellerId(event.sellerId);
        print("Brands fetched successfully: ${brands.map((b) => b.toJson())}");
        emit(BrandsLoaded(brands));
      } catch (e) {
        print("Fetching brands failed: $e");
        emit(BrandFailure(e.toString()));
      }
    });

  }
}
