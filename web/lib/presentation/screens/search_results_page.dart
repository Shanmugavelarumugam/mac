import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_app/logic/bloc/search/search_bloc.dart';
import 'package:web_app/logic/bloc/search/search_event.dart';
import 'package:web_app/logic/bloc/search/search_state.dart';
import 'package:web_app/data/repository/search_repository.dart';
import 'package:web_app/data/model/image_result_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:web_app/presentation/screens/image_results_page.dart';
import 'package:web_app/presentation/screens/in_app_browser.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final SearchRepository repository;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.repository,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late SearchBloc searchBloc;
  late TextEditingController searchController;
  String selectedFilter = 'All';
  bool showImages = false;

  final List<String> filters = [
    'All',
    'Images',
    'News',
    'Videos',
    'Shopping',
    'Maps',
    'Books',
  ];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.query);
    searchBloc = SearchBloc(widget.repository);
    searchBloc.add(SearchTextEvent(widget.query));
  }

  @override
  void dispose() {
    searchController.dispose();
    searchBloc.close();
    super.dispose();
  }

  bool _isProbablyUrl(String input) {
    final uri = Uri.tryParse(input);
    return uri != null && (uri.hasScheme || input.contains('.'));
  }

  void _performSearch(String value) {
    if (_isProbablyUrl(value)) {
      final url = value.startsWith("http") ? value : "https://$value";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InAppBrowserPage(url: url)),
      );
    } else {
      setState(() {
        selectedFilter = 'All';
        showImages = false;
      });
      searchBloc.add(SearchTextEvent(value));
    }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      showImages = filter == 'Images';
    });

    if (showImages) {
      searchBloc.add(SearchImagesEvent(searchController.text));
    } else {
      searchBloc.add(SearchTextEvent(searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[300]! : Colors.black;
    final urlColor = isDark ? Colors.green[300]! : Colors.green[800]!;
    final dividerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final cardColor = isDark ? Colors.grey[850]! : Colors.grey[50];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      'BTC',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 18,
                    child: Text(
                      "H",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(color: dividerColor, width: 0.5),
              ),
            ),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.search,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: textColor, fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search BTC or type a URL',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      onSubmitted: _performSearch,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      searchController.clear();
                      searchBloc.add(SearchTextEvent(''));
                    },
                    icon: Icon(
                      Icons.clear,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Tabs
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(color: dividerColor, width: 0.5),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;

                return GestureDetector(
                  onTap: () => _onFilterSelected(filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? Colors.blue[600]!
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.blue[600]
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Search Results / Images
          Expanded(
            child: BlocProvider.value(
              value: searchBloc,
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (showImages) {
                    return ImageResultsPage(
                      repository: widget.repository,
                      query: searchController.text,
                      textColor: textColor,
                    );
                  } else if (state is SearchTextLoaded) {
                    if (state.results.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: state.results.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 32,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      itemBuilder: (context, index) {
                        final result = state.results[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    InAppBrowserPage(url: result.url),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.url,
                                style: TextStyle(color: urlColor, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.title,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.snippet,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
