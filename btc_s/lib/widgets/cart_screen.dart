import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart'; // ✅ Import constants
import '../utils/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final userId = await UserPreferences.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view cart')),
      );
      return;
    }

    final String apiUrl =
        '${AppConstants.baseUrl}/api/cart/$userId'; // ✅ Used constant

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          cartItems = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cart (${response.statusCode})'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error fetching cart')));
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    final String apiUrl =
        '${AppConstants.baseUrl}/api/cart/$cartId'; // ✅ Used constant

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Item removed from cart')));
        fetchCartItems(); // Refresh after deletion
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete item')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error deleting item')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : cartItems.isEmpty
              ? Center(
                child: Text('Cart is empty', style: GoogleFonts.montserrat()),
              )
              : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item['Product'];

                  if (product == null) {
                    return const ListTile(title: Text('Product not available'));
                  }

                  final imageUrl = AppConstants.imageUrl(
                    product['image'],
                  ); // ✅ Used constant
                  final name = product['description'] ?? '';
                  final price = product['cost'] ?? '';
                  final quantity = item['quantity'];
                  final cartId = item['id'];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        name,
                        style: GoogleFonts.montserrat(fontSize: 14),
                      ),
                      subtitle: Text(
                        '₹$price  |  Qty: $quantity',
                        style: GoogleFonts.montserrat(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => deleteCartItem(cartId),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
