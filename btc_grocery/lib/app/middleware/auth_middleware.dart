import 'package:btc_grocery/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn.value
        ? null
        : const RouteSettings(name: AppRouteNames.login);
  }
}
