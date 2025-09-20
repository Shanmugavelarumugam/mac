import 'package:btc_store/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final dashboard = await repository.getSellerDashboard();
        emit(DashboardLoaded(dashboard)); // ✅ emit loaded state
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
