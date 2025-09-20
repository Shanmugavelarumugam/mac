class ImageResult {
  final String altText;
  final String imageUrl;
  final String pageUrl;
  final String filename;
  final double rank;

  ImageResult({
    required this.altText,
    required this.imageUrl,
    required this.pageUrl,
    required this.filename,
    required this.rank,
  });

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(
      altText: json['alt_text'] ?? '',
      imageUrl: json['image_url'] ?? '',
      pageUrl: json['page_url'] ?? '',
      filename: json['filename'] ?? '',
      rank: (json['rank'] ?? 0).toDouble(),
    );
  }
}
