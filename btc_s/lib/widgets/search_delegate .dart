import 'package:btc_s/utils/shared_preferences.dart';
import 'package:btc_s/widgets/search_results_screen.dart';
import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Save to recent searches ✅
    UserPreferences.addRecentSearch(query);

    // Navigate to results screen
    Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsScreen(searchQuery: query),
        ),
      );
    });

    return const SizedBox(); // Just return empty widget
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: UserPreferences.getRecentSearches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final suggestions = snapshot.data!;
        return ListView(
          children:
              suggestions
                  .map(
                    (s) => ListTile(
                      title: Text(s),
                      onTap: () {
                        query = s;
                        showResults(context); // trigger buildResults()
                      },
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
