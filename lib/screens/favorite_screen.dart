import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:newsapi/screens/article.models.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articleBox = Hive.box<ArticleModels>('articles');

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: articleBox.length,
        itemBuilder: (context, index) {
          final article = articleBox.getAt(index) as ArticleModels;
          if (article.isFavorite) {
            return ListTile(
              title: Text(article.title),
            //  subtitle: Text(article.desc),
              leading: Image.network(article.imageUrl),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

