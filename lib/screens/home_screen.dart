import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/news_api_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  final RxList<Article> _articles = <Article>[].obs;
  final RxBool _isLoading = true.obs;
  final RxString _searchQuery = 'flutter'.obs;
  final RxString _selectedCategory = ''.obs;

  final List<String> _categories = [
    'Business', 'Technology', 'Sports', 'Health', 'Entertainment', 'Science'
  ];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    _isLoading.value = true;
    try {
      final articles = await _newsApiService.fetchArticles(
        query: _searchQuery.value,
        category: _selectedCategory.value,
      );
      _articles.value = articles;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load news: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: const Text('New📰Vibes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchNews();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (value) {
                _searchQuery.value = value.isEmpty ? 'flutter' : value;
                _selectedCategory.value = ''; // Clear category when searching
                _fetchNews();
              },
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Breaking News',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle See All press
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory.value == category.toLowerCase(),
                    onSelected: (selected) {
                      _selectedCategory.value = selected ? category.toLowerCase() : '';
                      _searchQuery.value = 'flutter'; // Reset search query when category is selected
                      _fetchNews();
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Obx(
              () => _isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _articles.isEmpty
                      ? const Center(child: Text('No articles found.'))
                      : ListView.builder(
                          itemCount: _articles.length,
                          itemBuilder: (context, index) {
                            final article = _articles[index];
                            return NewsCard(article: article);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}