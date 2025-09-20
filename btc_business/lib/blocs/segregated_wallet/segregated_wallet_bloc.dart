import 'package:flutter_bloc/flutter_bloc.dart';
import 'segregated_wallet_event.dart';
import 'segregated_wallet_state.dart';
import '../../data/models/segregated_wallet.dart';
import 'package:uuid/uuid.dart';

class SegregatedWalletBloc
    extends Bloc<SegregatedWalletEvent, SegregatedWalletState> {
  final List<SegregatedWallet> _wallets = [];
  final _uuid = Uuid();

  SegregatedWalletBloc() : super(WalletsInitial()) {
    on<LoadWallets>((event, emit) {
      emit(WalletsLoading());
      // Load wallets from storage here, mock for now
      emit(WalletsLoaded(List.from(_wallets)));
    });

    on<AddWallet>((event, emit) {
      _wallets.add(event.wallet);
      emit(WalletsLoaded(List.from(_wallets)));
    });

    on<EditWallet>((event, emit) {
      final index = _wallets.indexWhere((w) => w.id == event.wallet.id);
      if (index != -1 && _wallets[index].canEditOrDelete) {
        _wallets[index] = event.wallet;
        emit(WalletsLoaded(List.from(_wallets)));
      }
    });

    on<DeleteWallet>((event, emit) {
      final index = _wallets.indexWhere((w) => w.id == event.walletId);
      if (index != -1 && _wallets[index].canEditOrDelete) {
        _wallets.removeAt(index);
        emit(WalletsLoaded(List.from(_wallets)));
      }
    });

    on<AddFunds>((event, emit) {
      final index = _wallets.indexWhere((w) => w.id == event.walletId);
      if (index != -1) {
        final wallet = _wallets[index];
        wallet.currentAmount += event.amount;
        final updatedTransactions = List<Transaction>.from(wallet.transactions)
          ..add(
            Transaction(
              id: _uuid.v4(),
              amount: event.amount,
              date: DateTime.now(),
              type: 'add',
              note: event.note,
            ),
          );
        _wallets[index] = wallet.copyWith(transactions: updatedTransactions);
        emit(WalletsLoaded(List.from(_wallets)));
      }
    });

    on<ClaimFunds>((event, emit) {
      final index = _wallets.indexWhere((w) => w.id == event.walletId);
      if (index != -1) {
        final wallet = _wallets[index];
        if (wallet.isTargetReached && event.amount <= wallet.currentAmount) {
          final newAmount = wallet.currentAmount - event.amount;
          final updatedTransactions = List<Transaction>.from(
            wallet.transactions,
          )..add(
            Transaction(
              id: _uuid.v4(),
              amount: event.amount,
              date: DateTime.now(),
              type: 'claim',
              note: event.note,
            ),
          );
          _wallets[index] = wallet.copyWith(
            currentAmount: newAmount,
            transactions: updatedTransactions,
          );
          emit(WalletsLoaded(List.from(_wallets)));
        }
      }
    });
  }
}
