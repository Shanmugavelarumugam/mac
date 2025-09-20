import 'package:btc_store/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btc_store/bloc/auth/auth_bloc.dart';
import 'package:btc_store/bloc/dashboard/dashboard_bloc.dart';
import 'package:btc_store/bloc/dashboard/dashboard_event.dart';
import 'package:btc_store/data/repositories/dashboard_repository.dart';
import 'package:btc_store/presentation/screens/home/dashboard.dart';

class SellerDashboardWrapper extends StatelessWidget {
  const SellerDashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    if (authState is AuthSuccess) {
      final token = authState.response.token;
      if (token == null || token.isEmpty) {
        return const Scaffold(body: Center(child: Text("Invalid session")));
      }

      return BlocProvider(
        create: (_) =>
            DashboardBloc(repository: DashboardRepository(token: token))
              ..add(FetchDashboard()),
        child: const SellerDashboard(),
      );
    }

    return const Scaffold(body: Center(child: Text("Not authenticated")));
  }
}
