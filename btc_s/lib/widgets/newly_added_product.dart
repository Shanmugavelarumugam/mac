import 'dart:convert';
import 'package:btc_s/utils/constants.dart';
import 'package:btc_s/widgets/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NewlyAddedProducts extends StatefulWidget {
  final String? category; // 🔑 Pass category as optional

  const NewlyAddedProducts({super.key, this.category});

  @override
  State<NewlyAddedProducts> createState() => _NewlyAddedProductsState();
}

class _NewlyAddedProductsState extends State<NewlyAddedProducts> {
  List<dynamic> newProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewArrivals();
  }

  Future<void> fetchNewArrivals() async {
    final String apiUrl = '${AppConstants.baseUrl}/api/products/new-arrivals';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(response.body);

        setState(() {
          // 🔑 If category is provided, filter by category
          newProducts =
              widget.category == null
                  ? products
                  : products
                      .where(
                        (product) =>
                            (product['category'] ?? '')
                                .toString()
                                .toLowerCase() ==
                            widget.category!.toLowerCase(),
                      )
                      .toList();

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load new arrivals');
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
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (newProducts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No New Arrivals Found',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: newProducts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = newProducts[index];
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
