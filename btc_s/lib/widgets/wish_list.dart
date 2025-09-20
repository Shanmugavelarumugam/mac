import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart'; // ✅ Import AppConstants
import '../utils/shared_preferences.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<dynamic> likedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLikedItems();
  }

  Future<void> fetchLikedItems() async {
    final userId = await UserPreferences.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view wishlist')),
      );
      return;
    }

    final String apiUrl =
        '${AppConstants.baseUrl}/api/liked/$userId'; // ✅ Using constant

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          likedItems = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load wishlist (${response.statusCode})'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error fetching wishlist')));
    }
  }

  Future<void> deleteLikedItem(int likedId) async {
    final String apiUrl =
        '${AppConstants.baseUrl}/api/liked/$likedId'; // ✅ Using constant

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed from wishlist')));
        fetchLikedItems();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to remove item')));
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
        title: Text('My Wishlist', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : likedItems.isEmpty
              ? Center(
                child: Text(
                  'Wishlist is empty',
                  style: GoogleFonts.montserrat(),
                ),
              )
              : ListView.builder(
                itemCount: likedItems.length,
                itemBuilder: (context, index) {
                  final item = likedItems[index];
                  final product = item['Product'];

                  if (product == null) {
                    return const ListTile(title: Text('Product not available'));
                  }

                  final imageUrl = AppConstants.imageUrl(
                    product['image'],
                  ); // ✅ Using constant
                  final name = product['description'] ?? '';
                  final price = product['cost'] ?? '';
                  final likedId = item['id'];

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
                        '₹$price',
                        style: GoogleFonts.montserrat(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => deleteLikedItem(likedId),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
