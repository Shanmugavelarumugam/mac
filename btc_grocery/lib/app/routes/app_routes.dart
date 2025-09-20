import 'package:get/get.dart';
import 'package:btc_grocery/views/auth/login_screen.dart';
import 'package:btc_grocery/views/auth/signup_screen.dart';
import 'package:btc_grocery/views/auth/forgot_password_screen.dart';
import 'package:btc_grocery/views/auth/reset_password_screen.dart';
import 'package:btc_grocery/views/auth/verify_otp_screen.dart';
import 'package:btc_grocery/views/home/home_screen.dart';
import 'package:btc_grocery/views/cart/cart_screen.dart';
import 'package:btc_grocery/views/wishlist/wishlist_screen.dart';
import 'package:btc_grocery/app/middleware/auth_middleware.dart';

class AppRouteNames {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const forgotPassword = '/forgot-password';
  static const verifyOtp = '/verify-otp';
  static const resetPassword = '/reset-password';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
}

class AppRoutes {
  static final routes = [
    GetPage(name: AppRouteNames.login, page: () => LoginScreen()),
    GetPage(name: AppRouteNames.signup, page: () => SignupScreen()),
    GetPage(
      name: AppRouteNames.home,
      page: () => HomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRouteNames.forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRouteNames.verifyOtp,
      page: () {
        final args = Get.arguments as Map<String, String>? ?? {};
        return VerifyOtpScreen(email: args['email'] ?? '');
      },
    ),
    GetPage(
      name: AppRouteNames.resetPassword,
      page: () {
        final args = Get.arguments as Map<String, String>? ?? {};
        return ResetPasswordScreen(email: args['email'] ?? '');
      },
    ),
    GetPage(name: AppRouteNames.cart, page: () => CartScreen()),
    GetPage(name: '/wishlist', page: () => WishlistScreen()),
  ];
}
