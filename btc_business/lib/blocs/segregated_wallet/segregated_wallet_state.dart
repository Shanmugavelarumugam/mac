import 'package:equatable/equatable.dart';
import '../../data/models/segregated_wallet.dart';

abstract class SegregatedWalletState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalletsInitial extends SegregatedWalletState {}

class WalletsLoading extends SegregatedWalletState {}

class WalletsLoaded extends SegregatedWalletState {
  final List<SegregatedWallet> wallets;

  WalletsLoaded(this.wallets);
  @override
  List<Object?> get props => [wallets];
}

class WalletsError extends SegregatedWalletState {
  final String message;

  WalletsError(this.message);
  @override
  List<Object?> get props => [message];
}
