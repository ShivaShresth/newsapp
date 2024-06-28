import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapi/models/article_model.dart';

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=cbbd8ee7728b4058bf6c02c74bab798e";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          jsonData["articles"].forEach((element) {
            if (element['urlToImage'] != null && element['description'] != null) {
              ArticleModel articleModel = ArticleModel(
                title: element['title'],
                description: element["description"],
                url: element["url"],
                urlToImage: element["urlToImage"],
                content: element["content"],
                author: element["author"],
              );
              news.add(articleModel);
            }
          });
        } else {
          throw Exception('Failed to fetch data');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      // Handle error here, e.g., show a dialog or toast to the user
    }
  }
}
