import 'package:btc_store/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class SellerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerLoaded extends SellerState {
  final SellerProfile profile;

  SellerLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class SellerUpdated extends SellerState {
  final String message;

  SellerUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class SellerError extends SellerState {
  final String error;

  SellerError(this.error);

  @override
  List<Object?> get props => [error];
}
