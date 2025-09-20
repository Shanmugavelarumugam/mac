
import 'package:btc_store/data/models/product_model.dart';
import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:btc_store/presentation/widgets/products/add_product_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/products/product_card.dart';

class ProductScreen extends StatefulWidget {
  final List<Product> products;
  final int sellerId;

  const ProductScreen({
    super.key,
    required this.products,
    required this.sellerId,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<void> _fetchProducts(int sellerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final repository = ProductRepository(token: token);
    try {
      final products = await repository.getProductsBySeller(sellerId);
      setState(() {
        widget.products.clear();
        widget.products.addAll(products);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch products: $e')));
    }
  }


  Future<void> _confirmDelete(Product product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: Text("Are you sure you want to delete '${product.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      if (product.id != null) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token == null || token.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication token missing')),
          );
          return;
        }

        try {
          final repository = ProductRepository(token: token);
          await repository.deleteProduct(product.id!);

          await _fetchProducts(widget.sellerId);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot delete product: missing ID')),
        );
      }
    }
  }




  void _navigateToEditProduct(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-product',
      arguments: product,
    );

    if (result == true) {
      await _fetchProducts(widget.sellerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildModernAppBar(context),
      body: widget.products.isEmpty
          ? _buildEmptyState(context)
          : LayoutBuilder(
              builder: (context, constraints) {
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth > 600 ? 24.0 : 16.0,
                        vertical: 20.0,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 900
                              ? 4
                              : constraints.maxWidth > 600
                              ? 3
                              : constraints.maxWidth > 400
                              ? 2
                              : 1,
                          childAspectRatio: constraints.maxWidth > 600
                              ? 0.6
                              : 0.46,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProductCard(
                            product: widget.products[index],
                            onEdit: () =>
                                _navigateToEditProduct(widget.products[index]),
                            onDelete: () =>
                                _confirmDelete(widget.products[index]),
                          ),
                          childCount: widget.products.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: const AddProductButton(),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "My Products",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Color(0xFF1E293B),
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0.5,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF475569),
            size: 18,
          ),
        ),
      ),
      actions: [
        _buildActionButton(Icons.search_rounded, () {}),
        _buildActionButton(Icons.tune_rounded, () {}),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF475569), size: 20),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Products Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Start adding products to see them here.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
