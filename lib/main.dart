import 'package:flutter/material.dart';
import 'package:newsapi/pages/home.dart';
import 'package:newsapi/screens/favorite_screen.dart';
import 'package:newsapi/screens/favroite_proivder.dart';
import 'package:newsapi/sqlitedatabase/favorite_provider.dart';
import 'package:newsapi/sqlitedatabase/favorite_screen.dart';
import 'package:newsapi/sqlitedatabase/splash_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..loadFavorites()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          '/favorites': (context) => FavoritesScreen(),
        },
      ),
    );
  }
}
