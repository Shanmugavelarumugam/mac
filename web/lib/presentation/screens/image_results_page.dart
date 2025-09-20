import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:web_app/data/model/image_result_model.dart';
import 'package:web_app/presentation/screens/in_app_browser.dart';
import 'package:web_app/data/repository/search_repository.dart';

class ImageResultsPage extends StatelessWidget {
  final SearchRepository repository;
  final String query;
  final Color textColor;

  const ImageResultsPage({
    super.key,
    required this.repository,
    required this.query,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageResult>>(
      future: repository.searchImages(query, page: 1, limit: 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: textColor),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No images found', style: TextStyle(color: textColor)),
          );
        }

        final images = snapshot.data!;
        return MasonryGridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: images.length,
          itemBuilder: (context, index) {
            final img = images[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InAppBrowserPage(url: img.imageUrl),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  img.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (c, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
