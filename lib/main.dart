import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapi/screens/favorite_screen.dart';
import 'package:newsapi/screens/favroite_proivder.dart';
import 'package:provider/provider.dart';
import 'package:newsapi/models/article_model.dart';
import 'package:newsapi/pages/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<ArticleModel>('favorites');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
        routes: {
          '/favorites': (context) => FavoritesScreen(),
        },
      ),
    );
  }
}
