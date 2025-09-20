/// Base configuration constants for API endpoints and other global settings.
class AppConstants {
  /// Change this IP/URL based on your backend server (e.g., for production or localhost)
  static const String baseUrl = 'http://192.168.1.6:3003/api';

  // 👤 User Auth Endpoints
  static const String loginUrl = '$baseUrl/users/login';
  static const String signupUrl = '$baseUrl/users';
  static const String logoutUrl = '$baseUrl/users/logout';

  static const String forgotPasswordUrl = '$baseUrl/auth/forgot-password';
  static const String verifyOtpUrl = '$baseUrl/auth/verify-otp';
  static const String resetPasswordUrl = '$baseUrl/auth/reset-password';

  // 🛒 Cart Endpoints
  static const String cartBase = '$baseUrl/cart';

  // 🛍️ Product & Category
  static const String productsUrl = '$baseUrl/products';
  static const String categoriesUrl = '$baseUrl/categories';

  // 💬 Reviews
  static const String reviewBase = '$baseUrl/reviews';

  // 💖 Wishlist
  static const String wishlistBase = '$baseUrl/wishlist';
}
