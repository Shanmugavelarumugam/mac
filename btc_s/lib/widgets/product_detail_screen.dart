
import 'package:btc_s/widgets/review.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:btc_s/widgets/cart_screen.dart';
import 'package:btc_s/widgets/wish_list.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/shared_preferences.dart';
import 'product_detail_actions.dart';
import 'product_detail_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isWishlisted = false;
  int? wishlistId;
  String? selectedSize;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    checkIfWishlisted();
    trackProductLocally();
    if (widget.product['size'] != null && widget.product['size'].isNotEmpty) {
      selectedSize = widget.product['size'][0];
    }
  }

  Future<void> trackProductLocally() async {
    await UserPreferences.addRecentlyViewed(widget.product);
  }

  Future<void> checkIfWishlisted() async {
    await ProductDetailActions.checkIfWishlisted(
      context: context,
      productId: widget.product['id'],
      onWishlisted: (wishlisted, id) {
        setState(() {
          isWishlisted = wishlisted;
          wishlistId = id;
        });
      },
    );
  }

  Future<void> toggleWishlist() async {
    await ProductDetailActions.toggleWishlist(
      context: context,
      productId: widget.product['id'],
      isWishlisted: isWishlisted,
      wishlistId: wishlistId,
      onUpdated: (wishlisted, id) {
        setState(() {
          isWishlisted = wishlisted;
          wishlistId = id;
        });
      },
    );
  }

  Future<void> addToCart() async {
    await ProductDetailActions.addToCart(
      context: context,
      productId: widget.product['id'],
      quantity: quantity,
    );
  }

  void shareProduct() {
    final productName = widget.product['description'] ?? 'Product';
    final productPrice =
        widget.product['cost'] != null ? '₹${widget.product['cost']}' : '';
    final productId = widget.product['id'];
    final productLink = 'https://yourapp.com/product/$productId';

    final shareText = '''
🛍️ *$productName*
💰 Price: $productPrice

Check it out here:
$productLink
''';

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: shareProduct,
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishListScreen()),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductDetailWidgets.buildProductDetailScreen(
              context: context,
              product: widget.product,
              isWishlisted: isWishlisted,
              selectedSize: selectedSize,
              quantity: quantity,
              onSizeChanged: (value) => setState(() => selectedSize = value),
              onQuantityChanged: (value) => setState(() => quantity = value),
              onAddToCart: addToCart,
              onToggleWishlist: toggleWishlist,
            ),
            ReviewSection(product: widget.product),
          ],
        ),
      ),
      bottomNavigationBar: ProductDetailWidgets.buildBottomBar(
        context,
        isWishlisted,
        addToCart,
        toggleWishlist,
      ),
    );
  }
}
