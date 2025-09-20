import 'package:flutter/material.dart';
import 'package:web_app/data/model/download_status.dart';
import '../widgets/download_item.dart';
import '../utils/time_formatter.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

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
                "Downloads",
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
              _buildActionButton(Icons.search_outlined, isDark, () {}),
              _buildActionButton(
                Icons.clear_all_outlined,
                isDark,
                () {},
                tooltip: 'Clear all',
              ),
              _buildActionButton(Icons.more_vert, isDark, () {}),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              padding: const EdgeInsets.all(24),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4285F4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.storage_outlined,
                          color: const Color(0xFF4285F4),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Storage usage",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF202124),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "2.3 GB used",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF5F6368),
                            ),
                          ),
                          Text(
                            "10 GB total",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white60
                                  : const Color(0xFF5F6368),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.23,
                          minHeight: 6,
                          backgroundColor: isDark
                              ? const Color(0xFF3C3C3C)
                              : const Color(0xFFE8EAED),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4285F4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.cleaning_services_outlined,
                              size: 16,
                            ),
                            label: const Text("Free up space"),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF4285F4),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          Text(
                            "7.7 GB available",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white60
                                  : const Color(0xFF5F6368),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDownloadGroup("Today", [
                  buildDownloadItem(
                    "Flutter SDK Setup.zip",
                    "245 MB",
                    Icons.folder_zip_outlined,
                    const Color(0xFF4285F4),
                    DownloadStatus.completed,
                    isDark,
                    DateTime.now().subtract(const Duration(hours: 2)),
                  ),
                  buildDownloadItem(
                    "Design Resources Pack.zip",
                    "1.2 GB",
                    Icons.design_services_outlined,
                    const Color(0xFFFF9800),
                    DownloadStatus.downloading,
                    isDark,
                    DateTime.now().subtract(const Duration(minutes: 30)),
                    progress: 0.65,
                  ),
                ], isDark),
                const SizedBox(height: 24),
                _buildDownloadGroup("Yesterday", [
                  buildDownloadItem(
                    "API Documentation.pdf",
                    "87 MB",
                    Icons.description_outlined,
                    const Color(0xFF34A853),
                    DownloadStatus.completed,
                    isDark,
                    DateTime.now().subtract(const Duration(days: 1)),
                  ),
                  buildDownloadItem(
                    "Video Tutorials Collection.mp4",
                    "2.4 GB",
                    Icons.play_circle_outline,
                    const Color(0xFFEA4335),
                    DownloadStatus.paused,
                    isDark,
                    DateTime.now().subtract(const Duration(days: 1, hours: 5)),
                    progress: 0.35,
                  ),
                ], isDark),
                const SizedBox(height: 24),
                _buildDownloadGroup("This week", [
                  buildDownloadItem(
                    "E-book Collection.epub",
                    "654 MB",
                    Icons.menu_book_outlined,
                    const Color(0xFF9C27B0),
                    DownloadStatus.completed,
                    isDark,
                    DateTime.now().subtract(const Duration(days: 3)),
                  ),
                ], isDark),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
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

  Widget _buildDownloadGroup(String title, List<Widget> items, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : const Color(0xFF5F6368),
              letterSpacing: 0.1,
            ),
          ),
        ),
        ...items.map(
          (item) =>
              Padding(padding: const EdgeInsets.only(bottom: 8), child: item),
        ),
      ],
    );
  }
}
