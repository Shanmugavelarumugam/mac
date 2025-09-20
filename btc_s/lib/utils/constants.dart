class AppConstants {
  static const String baseUrl = 'http://192.168.1.6:3001';
  static const String productsApi = '$baseUrl/api/products';
  static const String loginApi = '$baseUrl/api/users/login';
  static const String signUpApi = '$baseUrl/api/users/signup';

  static String imageUrl(String imageName) => '$baseUrl/uploads/$imageName';
}
