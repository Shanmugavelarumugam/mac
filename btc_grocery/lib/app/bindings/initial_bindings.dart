import 'package:get/get.dart';
import 'package:btc_grocery/controllers/auth_controller.dart';
import 'package:btc_grocery/controllers/home_controller.dart';
import 'package:btc_grocery/controllers/wishlist_controller.dart'; // ✅ add this
import 'package:btc_grocery/services/local/secure_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SecureStorageService(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(WishlistController(), permanent: true); // ✅ add this
  }
}
