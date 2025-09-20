import 'package:btc_store/presentation/screens/auth/login_screen.dart';
import 'package:btc_store/presentation/screens/auth/signup_screen.dart';
import 'package:btc_store/presentation/screens/home/SellerDashboardWrapper.dart';
import 'package:btc_store/presentation/widgets/products/edit_product.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String noAccess = '/no-access';
  static const String editProduct = '/edit-product'; // 👈 added

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    home: (_) => const SellerDashboardWrapper(),
    editProduct: (_) => EditProductScreen(), // 👈 added here
  };
}
