import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapp/pages/article_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedArticlesScreen extends StatefulWidget {
  @override
  _SavedArticlesScreenState createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  List<String> savedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  void _loadSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    savedArticles = prefs.getStringList('savedArticles') ?? [];
    setState(() {});
  }

  @override
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Articles'),
      ),
      body: savedArticles.isEmpty
          ? Center(child: Text('No saved articles'))
          : ListView.builder(
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                return _buildSavedArticleWidget(savedArticles[index]);
              },
            ),
    );
  }

  Widget _buildSavedArticleWidget(String articleData) {
    try {
      final articleMap = jsonDecode(articleData);
      return ListTile(
        title: Text(articleMap['title'] ?? ''),
        subtitle: Text(articleMap['desc'] ?? ''),
        leading: _buildArticleImage(articleMap['imageUrl'] ?? ''),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleView(
                blogUrl: articleMap['url'] ?? '',
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error decoding saved article data: $e');
      return Container();
    }
  }

  Widget _buildArticleImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/placeholder_image.jpg',
        width: 80,
        height: 150,
        fit: BoxFit.cover,
      );
    }
  }
}