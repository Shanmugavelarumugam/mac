import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:btc_grocery/models/category_model.dart';
import 'package:btc_grocery/models/product_model.dart';
import 'package:btc_grocery/services/api/product_service.dart';

class HomeController extends GetxController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ProductService _productService = ProductService();

  var userName = 'User'.obs;
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  var products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("✅ HomeController initialized");
    _loadUser();
    fetchAllData();
  }

  Future<void> _loadUser() async {
    final user = await _storage.read(key: 'username');
    if (user != null && user.isNotEmpty) {
      userName.value = user;
    }
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _productService.fetchCategories();
      final fetchedProducts = await _productService.fetchProducts();
      categories.assignAll(fetchedCategories);
      products.assignAll(fetchedProducts);
    } catch (e) {
      Get.snackbar("Error", "Failed to load data: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    Get.offAllNamed('/login');
  }
}
