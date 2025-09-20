import 'package:flutter/material.dart';
import 'package:web_app/data/model/saved_item_type.dart';
import '../widgets/stat_item.dart';
import '../widgets/category_chip.dart';
import '../widgets/saved_item.dart';
import '../utils/time_formatter.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String selectedCategory = "All";
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1F1F1F)
          : const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: isDark ? const Color(0xFF2D2D30) : Colors.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Saved",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF202124),
                  letterSpacing: -0.5,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
            actions: [
              _buildActionButton(
                Icons.search_outlined,
                isDark,
                () {},
                tooltip: 'Search saved items',
              ),
              _buildActionButton(
                isGridView
                    ? Icons.view_list_outlined
                    : Icons.grid_view_outlined,
                isDark,
                () {
                  setState(() {
                    isGridView = !isGridView;
                  });
                },
                tooltip: isGridView ? 'List view' : 'Grid view',
              ),
              _buildActionButton(Icons.more_vert, isDark, () {}),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D30) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF3C3C3C)
                      : const Color(0xFFE8EAED),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.grey).withOpacity(
                      0.1,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: buildStatItem(
                      "Total Saved",
                      "127",
                      Icons.bookmark_outline,
                      const Color(0xFF4285F4),
                      isDark,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark
                        ? const Color(0xFF3C3C3C)
                        : const Color(0xFFE8EAED),
                  ),
                  Expanded(
                    child: buildStatItem(
                      "This Month",
                      "23",
                      Icons.trending_up,
                      const Color(0xFF34A853),
                      isDark,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark
                        ? const Color(0xFF3C3C3C)
                        : const Color(0xFFE8EAED),
                  ),
                  Expanded(
                    child: buildStatItem(
                      "Collections",
                      "8",
                      Icons.folder_outlined,
                      const Color(0xFFFF9800),
                      isDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  buildCategoryChip("All", Icons.apps, 127, isDark),
                  buildCategoryChip(
                    "Articles",
                    Icons.article_outlined,
                    45,
                    isDark,
                  ),
                  buildCategoryChip("Images", Icons.image_outlined, 32, isDark),
                  buildCategoryChip(
                    "Videos",
                    Icons.play_circle_outline,
                    18,
                    isDark,
                  ),
                  buildCategoryChip("Links", Icons.link_outlined, 24, isDark),
                  buildCategoryChip(
                    "PDFs",
                    Icons.picture_as_pdf_outlined,
                    8,
                    isDark,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: isGridView
                ? _buildGridView(isDark)
                : _buildListView(isDark),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF4285F4),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Save new"),
        elevation: 8,
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    bool isDark,
    VoidCallback onPressed, {
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: IconButton(
        icon: Icon(
          icon,
          color: isDark ? Colors.white70 : const Color(0xFF5F6368),
          size: 22,
        ),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }

  Widget _buildListView(bool isDark) {
    return SliverList(
      delegate: SliverChildListDelegate([
        buildSavedItem(
          "Advanced Flutter Development Techniques",
          "A comprehensive guide covering advanced Flutter concepts, state management patterns, and performance optimization techniques for building scalable applications.",
          "flutter.dev/docs/advanced",
          Icons.article_outlined,
          const Color(0xFF4285F4),
          isDark,
          SavedItemType.article as SavedItemType,
          DateTime.now().subtract(const Duration(hours: 3)),
          tags: ["Flutter", "Development", "Guide"],
        ),
        buildSavedItem(
          "Modern UI Design Inspiration Gallery",
          "Curated collection of beautiful mobile app designs showcasing the latest trends in user interface design and user experience.",
          "dribbble.com/ui-inspiration",
          Icons.image_outlined,
          const Color(0xFF34A853),
          isDark,
          SavedItemType.image as SavedItemType,
          DateTime.now().subtract(const Duration(days: 1)),
          tags: ["Design", "UI/UX", "Inspiration"],
        ),
        buildSavedItem(
          "Dart Language Deep Dive - Advanced Features",
          "Explore advanced Dart programming concepts including mixins, extensions, null safety, and asynchronous programming patterns.",
          "dart.dev/guides/language",
          Icons.code_outlined,
          const Color(0xFFFF9800),
          isDark,
          SavedItemType.article as SavedItemType,
          DateTime.now().subtract(const Duration(days: 2)),
          tags: ["Dart", "Programming", "Tutorial"],
        ),
        buildSavedItem(
          "Material Design 3 Implementation Guide",
          "Complete guide to implementing Material You design system in your applications with dynamic colors and adaptive layouts.",
          "material.io/design/material-theming",
          Icons.palette_outlined,
          const Color(0xFF9C27B0),
          isDark,
          SavedItemType.article as SavedItemType,
          DateTime.now().subtract(const Duration(days: 3)),
          tags: ["Material Design", "Theming", "UI"],
        ),
        buildSavedItem(
          "REST API Integration Best Practices",
          "Learn how to effectively integrate REST APIs in Flutter applications with proper error handling, caching, and state management.",
          "api-guidelines.example.com",
          Icons.api_outlined,
          const Color(0xFFEA4335),
          isDark,
          SavedItemType.link as SavedItemType,
          DateTime.now().subtract(const Duration(days: 5)),
          tags: ["API", "Integration", "Best Practices"],
        ),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _buildGridView(bool isDark) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildListDelegate([
        buildGridItem(
          "Flutter Development",
          "flutter.dev",
          Icons.article_outlined,
          const Color(0xFF4285F4),
          isDark,
          ["Flutter", "Development"],
        ),
        buildGridItem(
          "UI Design Gallery",
          "dribbble.com",
          Icons.image_outlined,
          const Color(0xFF34A853),
          isDark,
          ["Design", "UI/UX"],
        ),
        buildGridItem(
          "Dart Programming",
          "dart.dev",
          Icons.code_outlined,
          const Color(0xFFFF9800),
          isDark,
          ["Dart", "Programming"],
        ),
        buildGridItem(
          "Material Design 3",
          "material.io",
          Icons.palette_outlined,
          const Color(0xFF9C27B0),
          isDark,
          ["Material Design"],
        ),
      ]),
    );
  }
}
