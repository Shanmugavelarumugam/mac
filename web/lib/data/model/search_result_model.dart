class SearchResult {
  final String title;
  final String url;
  final String snippet;
  final double rank;

  SearchResult({
    required this.title,
    required this.url,
    required this.snippet,
    required this.rank,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      snippet: json['snippet'] ?? '',
      rank: (json['rank'] ?? 0).toDouble(),
    );
  }
}
