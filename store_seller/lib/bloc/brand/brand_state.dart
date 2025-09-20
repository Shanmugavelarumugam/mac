import 'package:btc_store/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandSuccess extends BrandState {
  final Brand brand;
  const BrandSuccess(this.brand);
}

class BrandDeleted extends BrandState {}

class BrandFailure extends BrandState {
  final String error;
  const BrandFailure(this.error);
}

class BrandsLoaded extends BrandState {
  final List<Brand> brands;
  const BrandsLoaded(this.brands);

  @override
  List<Object?> get props => [brands];
}
