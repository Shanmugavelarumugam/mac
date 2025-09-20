import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../../services/api/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  // For product list (optional)
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoadingProducts = false.obs;

  // For single product detail
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);
  final RxBool isProductLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Fetch all products (optional use in home screen or list)
  Future<void> fetchAllProducts() async {
    try {
      isLoadingProducts.value = true;
      final result = await _productService.fetchProducts();
      products.assignAll(result);
    } catch (e) {
      print('❌ Error fetching all products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  /// Fetch a product by its ID
  Future<void> fetchProductById(int productId) async {
    try {
      isProductLoading.value = true;
      errorMessage.value = '';
      final result = await _productService.fetchProductById(productId);
      product.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching product detail: $e');
    } finally {
      isProductLoading.value = false;
    }
  }
}
