import 'package:btc_store/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

class CreateBrandEvent extends BrandEvent {
  final Brand brand;
  const CreateBrandEvent(this.brand);
}

class UpdateBrandEvent extends BrandEvent {
  final int id;
  final Map<String, dynamic> updates;
  const UpdateBrandEvent(this.id, this.updates);
}

class DeleteBrandEvent extends BrandEvent {
  final int id;
  const DeleteBrandEvent(this.id);
}

class FetchBrandsBySellerEvent extends BrandEvent {
  final int sellerId;
  const FetchBrandsBySellerEvent(this.sellerId);

  @override
  List<Object?> get props => [sellerId];
}
