import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String _apiKey = '5bbaec85a87389f50a4960af9a9dbc98';
  static const String _baseUrl = 'https://gnews.io/api/v4/';

  Future<List<Article>> fetchArticles({String query = 'flutter', String category = ''}) async {
    String url = '${_baseUrl}search?q=$query&token=$_apiKey';
    if (category.isNotEmpty) {
      url = '${_baseUrl}top-headlines?category=$category&lang=en&token=$_apiKey';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final NewsResponse newsResponse = NewsResponse.fromJson(data);
      return newsResponse.articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}