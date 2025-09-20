import 'package:equatable/equatable.dart';

abstract class SellerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSellerProfile extends SellerEvent {}

class UpdateSellerProfile extends SellerEvent {
  final Map<String, dynamic> updateData;

  UpdateSellerProfile(this.updateData);

  @override
  List<Object?> get props => [updateData];
}
