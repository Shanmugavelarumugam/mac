/// 🌐 API Base URL
const String baseUrl = 'http://192.168.1.6:3001/api';

/// 🔐 Auth Endpoints
const String loginApi = '$baseUrl/users/login';
const String signupApi = '$baseUrl/users/signup';
const String forgotPasswordApi = '$baseUrl/auth/user/forgot-password'; // ✅ added
const String verifyOtpApi = '$baseUrl/auth/verify-otp'; // ✅ NEW
const String resetPasswordApi =
    '$baseUrl/auth/user/reset-password'; // ✅ match this with backend route

/// 🍽️ Food Endpoints
const String allFoodsApi = '$baseUrl/foods';
String foodByCategoryApi(String category) =>
    '$baseUrl/foods/category/$category';
String deleteFoodApi(int id) => '$baseUrl/foods/$id';

/// 🛒 Cart Endpoints
String getCartApi(int userId) => '$baseUrl/carts/$userId';
String getFoodByIdApi(int foodId) => '$baseUrl/foods/$foodId';
String deleteCartItemApi(int cartItemId) => '$baseUrl/carts/$cartItemId';
String clearCartApi(int userId) => '$baseUrl/carts/clear/$userId';
String updateCartItemApi(int cartItemId) => '$baseUrl/carts/$cartItemId';

/// 🍽️ Restaurant Endpoints
String getRestaurantByLocationApi(String endpoint) =>
    '$baseUrl/restaurants/$endpoint';

/// 💖 Wishlist Endpoints
String getWishlistApi(int userId) => '$baseUrl/wish/$userId';
String deleteWishlistItemApi(int wishId) => '$baseUrl/wish/$wishId';
String clearWishlistApi(int userId) => '$baseUrl/wish/clear/$userId';

/// 👤 User Endpoints
const String getAllUsersApi = '$baseUrl/users';

// FOOD + RATING
String foodWithRatingApi(int foodId) => '$baseUrl/foods/$foodId/avg-rating';

// REVIEWS
String reviewsByFoodIdApi(int foodId) => '$baseUrl/reviews/$foodId';
const String postReviewApi = '$baseUrl/reviews';
String deleteReviewApi(int reviewId) => '$baseUrl/reviews/$reviewId';

// USERS
String getUserByIdApi(int userId) => '$baseUrl/users/$userId';

// WISHLIST
const String postWishApi = '$baseUrl/wish';

// CART
const String postCartApi = '$baseUrl/carts';

String getNearbyRestaurantsApi(double lat, double lon) =>
    '$baseUrl/restaurants/nearby?latitude=$lat&longitude=$lon';
