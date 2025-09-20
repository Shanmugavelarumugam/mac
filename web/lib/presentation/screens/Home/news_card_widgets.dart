import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_item_model.dart';

Widget buildNewsCard(bool isDark, Animation<double> newsCardAnimation) {
  final List<NewsItem> newsItems = [
    NewsItem(
      title: "Tech Breakthrough in AI Development",
      description:
          "New advancements in AI promise to revolutionize multiple industries.",
      fullContent:
          "Recent breakthroughs in artificial intelligence are set to transform industries ranging from healthcare to finance. Leading tech companies have announced new models with unprecedented capabilities in natural language processing and computer vision.",
      imageUrl:
          "https://images.unsplash.com/photo-1516321318423-ffd4db76e2e6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      source: "Tech News Daily",
      timeAgo: "2 hours ago",
    ),
    NewsItem(
      title: "Championship Finals Recap",
      description:
          "A thrilling conclusion to the season with unexpected results.",
      fullContent:
          "The championship finals concluded with a dramatic finish, as underdog teams outperformed expectations. Key highlights include standout performances and critical moments that defined the season's outcome.",
      imageUrl:
          "https://images.unsplash.com/photo-1516321318423-ffd4db76e2e6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      source: "Sports Weekly",
      timeAgo: "5 hours ago",
    ),
    NewsItem(
      title: "Market Trends Show Positive Growth",
      description:
          "Stock markets rally as investor confidence grows in tech sector.",
      fullContent:
          "Global stock markets have shown positive growth, driven by strong performances in the technology sector. Analysts attribute this to increased investor confidence and favorable economic policies boosting market sentiment.",
      imageUrl:
          "https://images.unsplash.com/photo-1590283603385-17ffb3a7ab73?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      source: "Finance Times",
      timeAgo: "1 day ago",
    ),
  ];

  return AnimatedBuilder(
    animation: newsCardAnimation,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(0, 30 * (1 - newsCardAnimation.value)),
        child: Opacity(
          opacity: newsCardAnimation.value,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 600
                  ? 600
                  : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Stories',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero, // remove default top padding
                  itemCount: newsItems.length,
                  itemBuilder: (context, index) {
                    final news = newsItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: buildNewsItemCard(context, news, isDark),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildNewsItemCard(BuildContext context, NewsItem news, bool isDark) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
    child: InkWell(
      onTap: () => showNewsDetail(context, news),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: news.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        news.source,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news.timeAgo,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  news.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: Icon(
                        Icons.bookmark_border,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                      label: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(
                        Icons.share,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                      label: Text(
                        'Share',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void showNewsDetail(BuildContext context, NewsItem news) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: news.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    news.source,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    news.timeAgo,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                news.title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                news.fullContent,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(
                      'https://example.com/news/${news.title.toLowerCase().replaceAll(' ', '-')}/',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Read Full Article',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
