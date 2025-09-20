import 'package:btc_grocery/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/app/routes/app_routes.dart';
import 'package:btc_grocery/views/splash/splash_screen.dart';
import 'package:btc_grocery/app/bindings/initial_bindings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTC Grocery',
      initialBinding: InitialBinding(),
      initialRoute: AppRouteNames.splash,
      getPages: [
        GetPage(name: AppRouteNames.splash, page: () => const SplashScreen()),
        ...AppRoutes.routes,
      ],
    ),
  );
}
