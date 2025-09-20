import 'package:equatable/equatable.dart';
import '../../data/models/segregated_wallet.dart';

abstract class SegregatedWalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWallets extends SegregatedWalletEvent {}

class AddWallet extends SegregatedWalletEvent {
  final SegregatedWallet wallet;
  AddWallet(this.wallet);
  @override
  List<Object?> get props => [wallet];
}

class EditWallet extends SegregatedWalletEvent {
  final SegregatedWallet wallet;
  EditWallet(this.wallet);
  @override
  List<Object?> get props => [wallet];
}

class DeleteWallet extends SegregatedWalletEvent {
  final String walletId;
  DeleteWallet(this.walletId);
  @override
  List<Object?> get props => [walletId];
}

class AddFunds extends SegregatedWalletEvent {
  final String walletId;
  final double amount;
  final String? note;
  AddFunds(this.walletId, this.amount, {this.note});
  @override
  List<Object?> get props => [walletId, amount, note];
}

class ClaimFunds extends SegregatedWalletEvent {
  final String walletId;
  final double amount;
  final String? note;
  ClaimFunds(this.walletId, this.amount, {this.note});
  @override
  List<Object?> get props => [walletId, amount, note];
}
