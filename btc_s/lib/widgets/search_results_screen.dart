import 'dart:convert';
import 'package:btc_s/utils/constants.dart';
import 'package:btc_s/widgets/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<dynamic> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

 Future<void> fetchSearchResults() async {
    final String apiUrl = '${AppConstants.baseUrl}/api/products';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(response.body);
        final String query = widget.searchQuery.toLowerCase();

        setState(() {
          searchResults =
              products.where((product) {
                final description =
                    (product['description'] ?? '').toString().toLowerCase();
                final details =
                    (product['details'] ?? '').toString().toLowerCase();
                final tagsList = (product['tags'] ?? []) as List;
                final tags = tagsList.join(' ').toLowerCase();

                // ✅ Check in description, details, and tags
                return description.contains(query) ||
                    details.contains(query) ||
                    tags.contains(query);
              }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Search Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results for "${widget.searchQuery}"',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : searchResults.isEmpty
              ? Center(
                child: Text(
                  'No results found.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final product = searchResults[index];
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
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  price,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
