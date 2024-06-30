import 'package:flutter/material.dart';
import 'package:newsapi/pages/home.dart';
import 'package:newsapi/screens/favroite_proivder.dart';
import 'package:newsapi/sqlitedatabase/favorite_provider.dart';
import 'package:provider/provider.dart';


class FavoritesScreen extends StatelessWidget {
     ScrollController? scrollController;
  bool _isBottomBarVisible = true;
  bool _isAppBarVisible = true;
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favoriteArticles = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites',style: TextStyle(color: Colors.white60),),
        backgroundColor: Colors.red,
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
          bottomNavigationBar: AnimatedCrossFade(
        
        duration: Duration(milliseconds:300),
        crossFadeState: _isBottomBarVisible?CrossFadeState.showFirst:CrossFadeState.showSecond,
        firstChild: BottomNavigationBar(
          backgroundColor: Colors.green,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.red,
              icon: Icon(Icons.home, color: Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.black),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.black),
              label: 'Favorites',
              
            ),
          ],
          onTap: (index) {
            if (index == 3) {
                 Navigator.pushReplacementNamed(context, '/favorites');

            }
            if(index==0){  
             Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => Home()),
);

            }
          },
        ),
        secondChild: SizedBox.shrink(),
      ),
    );
  }
}
