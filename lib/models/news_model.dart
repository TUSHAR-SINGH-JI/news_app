class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;
  final DateTime publishedAt;
  final String articleUrl;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    required this.articleUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      sourceName: json['source']['name'] ?? 'Unknown Source',
      publishedAt: DateTime.parse(json['publishedAt']),
      articleUrl: json['url'] ?? 'https://example.com',
    );
  }
}

class NewsResponse {
  final List<Article> articles;

  NewsResponse({
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> articlesJson = json['articles'] ?? [];
    final List<Article> articles = articlesJson
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();
    return NewsResponse(articles: articles);
  }
}