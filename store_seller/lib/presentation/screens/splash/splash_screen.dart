import 'dart:async';
import 'package:btc_store/bloc/auth/auth_bloc.dart';
import 'package:btc_store/bloc/auth/auth_event.dart';
import 'package:btc_store/bloc/auth/auth_state.dart';
import 'package:btc_store/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<AuthState>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (token != null && token.isNotEmpty && userId != null && userId > 0) {
      print("[SplashScreen] Restoring session...");

      final authBloc = context.read<AuthBloc>();

      _subscription = authBloc.stream.listen((state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          _subscription?.cancel();
        } else if (state is AuthFailure) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
          _subscription?.cancel();
        }
      });

      // Add event after listener is attached
      Future.microtask(() {
        authBloc.add(RestoreSessionEvent(token: token, userId: userId));
      });
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }


  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Loading...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
