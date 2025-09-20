import 'package:btc_store/data/models/product_model.dart';
import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:btc_store/presentation/screens/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsLoaderScreen extends StatefulWidget {
  const ProductsLoaderScreen({super.key});

  @override
  State<ProductsLoaderScreen> createState() => _ProductsLoaderScreenState();
}

class _ProductsLoaderScreenState extends State<ProductsLoaderScreen> {
  List<Product> products = [];
  bool isLoading = true;

  // 👇 add sellerId as a state variable
  int? sellerId;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final storedSellerId = prefs.getInt('user_id') ?? 0;

      final repo = ProductRepository(token: token);
      final fetched = await repo.getProductsBySeller(storedSellerId);

      if (!mounted) return;
      setState(() {
        sellerId = storedSellerId; // ✅ save sellerId
        products = fetched;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        products = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ ensure sellerId is not null
    if (sellerId == null || sellerId == 0) {
      return const Scaffold(body: Center(child: Text("Seller ID not found")));
    }

    return ProductScreen(
      products: products,
      sellerId: sellerId!, // ✅ now available here
    );
  }
}
