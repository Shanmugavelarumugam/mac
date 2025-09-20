import 'dart:convert';
import 'package:btc_s/utils/constants.dart';
import 'package:btc_s/widgets/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class KidsProductsScreen extends StatefulWidget {
  const KidsProductsScreen({super.key});

  @override
  State<KidsProductsScreen> createState() => _KidsProductsScreenState();
}

class _KidsProductsScreenState extends State<KidsProductsScreen> {
  List<dynamic> kidsProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKidsProducts();
  }

  Future<void> fetchKidsProducts() async {
    final String apiUrl = AppConstants.productsApi;

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(response.body);
        setState(() {
          kidsProducts =
              products
                  .where((product) => product['category'] == 'Kids')
                  .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kidsProducts.isEmpty) {
      return Center(
        child: Text(
          'No Kids Products Found',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kidsProducts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = kidsProducts[index];
          final imageUrl = AppConstants.imageUrl(product['image']);
          final name = product['description'] ?? '';
          final price = '₹${product['cost']}';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 130,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
