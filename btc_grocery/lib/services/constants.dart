class ApiConstants {
  static const String baseUrl = 'http://192.168.1.6:3003/api';

  // Users
  static const String users = '$baseUrl/users';
  static String getUserById(int id) => '$users/$id';
  static String updateUser(int id) => '$users/$id';
  static String deleteUser(int id) => '$users/$id';
    static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';



  // Auth
  static const String login = '$users/login';
  static const String logout = '$users/logout';
  static const String signup = '$users'; // POST to /users is register

  // Cart (if still used)
  static const String carts = '$baseUrl/carts';
  static String userCart(int userId) => '$carts/$userId';
  static String clearCart(int userId) => '$carts/clear/$userId';
  static String removeCartItem(int cartItemId) => '$carts/$cartItemId';

  // Wishlist (if still used)
  static const String wishlist = '$baseUrl/wish';
  static String getWishlist(int userId) => '$wishlist/$userId';
  static String deleteWishlistItem(int userId, int foodId) =>
      '$wishlist/$userId?foodId=$foodId';
  static String clearWishlist(int userId) => '$wishlist/clear/$userId';
}
