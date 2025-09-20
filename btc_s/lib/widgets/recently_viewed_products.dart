import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/shared_preferences.dart';
import 'product_detail_screen.dart';

class RecentlyViewedProducts extends StatefulWidget {
  const RecentlyViewedProducts({super.key});

  @override
  State<RecentlyViewedProducts> createState() => _RecentlyViewedProductsState();
}

class _RecentlyViewedProductsState extends State<RecentlyViewedProducts> {
  List<dynamic> recentlyViewed = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecentlyViewed();
  }

  // ✅ Load from SharedPreferences
  Future<void> loadRecentlyViewed() async {
    setState(() => isLoading = true);
    final list = await UserPreferences.getRecentlyViewed();
    setState(() {
      recentlyViewed = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Viewed',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Show All', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (recentlyViewed.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No Recently Viewed Products'),
          )
        else
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentlyViewed.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final product = recentlyViewed[index];
                final imageUrl = AppConstants.imageUrl(product['image']);
                final name = product['description'] ?? '';
                final price = '₹${product['cost']}';

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                    await loadRecentlyViewed(); // refresh after returning
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          price,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors
                                    .black, // Or use Colors.green if you prefer price in green
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
