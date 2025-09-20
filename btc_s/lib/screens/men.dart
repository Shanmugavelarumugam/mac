import 'dart:convert';
import 'package:btc_s/utils/constants.dart';
import 'package:btc_s/utils/shared_preferences.dart';
import 'package:btc_s/widgets/newly_added.dart';
import 'package:btc_s/widgets/newly_added_product.dart';
import 'package:btc_s/widgets/product_detail_screen.dart';
import 'package:btc_s/widgets/recently_viewed_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MenProductsScreen extends StatefulWidget {
  const MenProductsScreen({super.key});

  @override
  State<MenProductsScreen> createState() => _MenProductsScreenState();
}

class _MenProductsScreenState extends State<MenProductsScreen> {
  List<dynamic> menProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenProducts();
  }

  Future<void> fetchMenProducts() async {
    final String apiUrl = AppConstants.productsApi;

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(response.body);
        setState(() {
          menProducts =
              products
                  .where((product) => product['category'] == 'Men')
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧥 Men Products Section
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (menProducts.isEmpty)
              Center(
                child: Text(
                  'No Men Products Found',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: menProducts.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = menProducts[index];
                    final imageUrl = AppConstants.imageUrl(product['image']);
                    final name = product['description'] ?? '';
                    final price = '₹${product['cost']}';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ProductDetailScreen(product: product),
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
              ),
            const SizedBox(height: 10),
            const NewlyAdded(),
            const SizedBox(height: 10),
            const NewlyAddedProducts(category: 'Men'),
            const SizedBox(height: 10),
            const RecentlyViewedProducts(),
          ],
        ),
      ),
    );
  }
}
