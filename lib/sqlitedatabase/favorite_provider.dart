import 'package:flutter/material.dart';
import 'package:newsapi/sqlitedatabase/database_helper.dart';
import 'package:newsapi/sqlitedatabase/favorite_article.dart';

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteArticle> _favorites = [];

  List<FavoriteArticle> get favorites => _favorites;

  void addFavorite(FavoriteArticle article) {
    _favorites.add(article);
    DatabaseHelper.instance.create(article);
    notifyListeners();
  }

  void removeFavorite(FavoriteArticle article) {
    _favorites.remove(article);
    DatabaseHelper.instance.delete(article.id!);
    notifyListeners();
  }

  bool isFavorite(FavoriteArticle article) {
    return _favorites.any((fav) => fav.id == article.id);
  }

  Future<void> loadFavorites() async {
    _favorites = await DatabaseHelper.instance.readAllFavoriteArticles();
    notifyListeners();
  }
}
