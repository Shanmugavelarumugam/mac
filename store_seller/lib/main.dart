import 'package:btc_store/bloc/auth/auth_bloc.dart';
import 'package:btc_store/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authRepository = AuthRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: authRepository)),
        // ⚠️ Removed global DashboardBloc, since it needs token -> created inside SellerDashboardWrapper
      ],
      child: const MyApp(),
    ),
  );
}
