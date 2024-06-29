// import 'package:flutter/material.dart';
// import 'package:newsapi/pages/home.dart';
// import 'package:newsapi/screens/favroite_proivder.dart';
// import 'package:provider/provider.dart';
// import 'package:newsapi/models/article_models.dart';
// import 'package:newsapi/pages/article_view.dart';

// class FavoritesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Favorites"),
//       ),
//       body: Consumer<FavoritesProvider>(
//         builder: (context, favoritesProvider, child) {
//           final favorites = favoritesProvider.favorites;
//           return favorites.isEmpty
//               ? Center(
//                   child: Text("No favorites added."),
//                 )
//               : ListView.builder(
//                   itemCount: favorites.length,
//                   itemBuilder: (context, index) {
//                     return BlogTile(
//                       url: favorites[index].url!,
//                       desc: favorites[index].description!,
//                       title: favorites[index].title!,
//                       imageUrl: favorites[index].urlToImage!,
//                       isFavorite: true,
//                       onFavoriteToggle: () {
//                         context.read<FavoritesProvider>().removeFavorite(favorites[index]);
//                       },
//                     );
//                   },
//                 );
//         },
//       ),
//     );
//   }
// }
