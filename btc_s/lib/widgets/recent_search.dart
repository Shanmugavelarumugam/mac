import 'package:btc_s/widgets/search_results_screen.dart'; // ✅ Import your SearchResultsScreen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentSearch extends StatefulWidget {
  const RecentSearch({super.key});

  @override
  State<RecentSearch> createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  List<String> recentItems = ['Shirts', 'Jeans', 'Sneakers', 'Watch', 'baby'];

  void removeItem(String item) {
    setState(() {
      recentItems.remove(item);
    });
  }

  void clearAll() {
    setState(() {
      recentItems.clear();
    });
  }

  void navigateToSearchResult(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(searchQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Recent Searches',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: clearAll,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, right: 8),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final double chipWidth = 110;
              final int itemsPerRow = (maxWidth / (chipWidth + 10)).floor();

              List<Row> rows = [];
              for (int i = 0; i < recentItems.length; i += itemsPerRow) {
                rows.add(
                  Row(
                    children:
                        recentItems.skip(i).take(itemsPerRow).map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              bottom: 10,
                            ),
                            child: GestureDetector(
                              onTap:
                                  () => navigateToSearchResult(
                                    context,
                                    item,
                                  ), // ✅ On tap action
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => removeItem(item),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rows,
              );
            },
          ),
        ],
      ),
    );
  }
}
