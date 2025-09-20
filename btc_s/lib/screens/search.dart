import 'package:btc_s/widgets/newly_added_product.dart';
import 'package:btc_s/widgets/popular_of_week.dart';
import 'package:btc_s/widgets/recent_search.dart';
import 'package:btc_s/widgets/search_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(searchQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: 360,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Image.asset(
                        'assets/search3.png',
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (_) => _onSearch(),
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        onPressed: _onSearch,
                      ),
                    ],
                  ),
                ),
              ),
              const RecentSearch(),
              PopularOfWeek(),
              NewlyAddedProducts()
            ],
          ),
        ),
      ),
    );
  }
}
