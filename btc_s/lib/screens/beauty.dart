import 'dart:convert';
import 'package:btc_s/utils/constants.dart';
import 'package:btc_s/widgets/newly_added.dart'; // ✅ Title Widget
import 'package:btc_s/widgets/newly_added_product.dart'; // ✅ Newly Added Products Widget
import 'package:btc_s/widgets/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BeautyScreen extends StatefulWidget {
  const BeautyScreen({super.key});

  @override
  State<BeautyScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<BeautyScreen> {
  List<dynamic> beautyProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBeautyProducts();
  }

  Future<void> fetchBeautyProducts() async {
    final String apiUrl = AppConstants.productsApi;

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(response.body);
        setState(() {
          beautyProducts =
              products
                  .where(
                    (product) =>
                        (product['category']?.toString().toLowerCase() ?? '') ==
                        'beauty',
                  )
                  .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load beauty products');
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
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (beautyProducts.isEmpty)
              Center(
                child: Text(
                  'No Beauty Products Found',
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
                  itemCount: beautyProducts.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = beautyProducts[index];
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

            const SizedBox(height: 0),

            // ✅ Newly Added Section
            const NewlyAdded(),

            const SizedBox(height: 10),

            // ✅ Newly Added Products filtered by 'Beauty' category
            const NewlyAddedProducts(category: 'Beauty'),
          ],
        ),
      ),
    );
  }
}
