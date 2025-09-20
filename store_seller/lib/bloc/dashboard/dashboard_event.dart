// dashboard_event.dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchDashboard extends DashboardEvent {}
