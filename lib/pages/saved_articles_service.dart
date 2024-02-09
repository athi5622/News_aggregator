import 'package:shared_preferences/shared_preferences.dart';


class SavedArticlesService {
  final SharedPreferences prefs;

  SavedArticlesService(this.prefs) {
    _prefs ??= _loadPrefs() as SharedPreferences?; 
  }

  static SharedPreferences? _prefs;

  Future<SharedPreferences> _loadPrefs() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
    
      throw Exception('Failed to initialize SharedPreferences: $e');
    }
  }


  List<String> getSavedArticles() {
    final savedUrls = prefs.getStringList('saved_articles') ?? [];
    return savedUrls;
  }

  Future<void> deleteArticle(String url) async {
    final savedUrls = prefs.getStringList('saved_articles') ?? [];
    if (savedUrls.contains(url)) {
      savedUrls.remove(url);
      await prefs.setStringList('saved_articles', savedUrls);
    }
  }

  Future<void> clearSavedArticles() async {
    await prefs.remove('saved_articles');
  }
}
