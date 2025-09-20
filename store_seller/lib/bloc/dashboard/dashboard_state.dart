// dashboard_state.dart
import 'package:btc_store/data/models/seller_dashboard_model.dart';
import 'package:equatable/equatable.dart';
import 'package:btc_store/data/models/dashboard_model.dart'; // ✅ use the correct model

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final SellerDashboardModel dashboard; // ✅ changed type

  DashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class DashboardError extends DashboardState {
  final String error;

  DashboardError(this.error);

  @override
  List<Object?> get props => [error];
}
