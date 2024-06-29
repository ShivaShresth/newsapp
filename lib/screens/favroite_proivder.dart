// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:newsapi/models/article_models.dart';

// class FavoritesProvider with ChangeNotifier {
//   late Box<ArticleModel> _favoritesBox;

//   FavoritesProvider() {
//     _favoritesBox = Hive.box<ArticleModel>('favorites');
//   }

//   List<ArticleModel> get favorites => _favoritesBox.values.toList();

//   void addFavorite(ArticleModel article) {
//     _favoritesBox.put(article.url, article);
//     notifyListeners();
//   }

//   void removeFavorite(ArticleModel article) {
//     _favoritesBox.delete(article.url);
//     notifyListeners();
//   }

//   bool isFavorite(ArticleModel article) {
//     return _favoritesBox.containsKey(article.url);
//   }
// }
