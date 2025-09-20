import 'package:btc_store/bloc/profile/profile_event.dart';
import 'package:btc_store/bloc/profile/profile_state.dart';
import 'package:btc_store/data/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final SellerRepository repository;

  SellerBloc({required this.repository}) : super(SellerInitial()) {
    on<FetchSellerProfile>((event, emit) async {
      emit(SellerLoading());
      try {
        final profile = await repository.getOwnProfile();
        emit(SellerLoaded(profile));
      } catch (e) {
        emit(SellerError(e.toString()));
      }
    });

    on<UpdateSellerProfile>((event, emit) async {
      emit(SellerLoading());
      try {
        final message = await repository.updateProfile(event.updateData);
        emit(SellerUpdated(message));

        // Reload profile after update
        final profile = await repository.getOwnProfile();
        emit(SellerLoaded(profile));
      } catch (e) {
        emit(SellerError(e.toString()));
      }
    });
  }
}
