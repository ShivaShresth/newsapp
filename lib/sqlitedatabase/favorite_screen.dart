import 'package:flutter/material.dart';
import 'package:newsapi/pages/home.dart';
import 'package:newsapi/screens/favroite_proivder.dart';
import 'package:newsapi/sqlitedatabase/favorite_provider.dart';
import 'package:provider/provider.dart';


class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favoriteArticles = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (context, index) {
          final article = favoriteArticles[index];
          final isFavorite = favoritesProvider.isFavorite(article);

          return BlogTile(
            url: article.url!,
            desc: article.description!,
            title: article.title!,
            imageUrl: article.urlToImage!,
            isFavorite: isFavorite,
            onFavoriteToggle: () {
              if (isFavorite) {
                favoritesProvider.removeFavorite(article);
              } else {
                favoritesProvider.addFavorite(article);
              }
            },
          );
        },
      ),
    );
  }
}
