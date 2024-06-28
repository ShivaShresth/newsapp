import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class ArticleModels extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String imageUrl;

  @HiveField(2)
  bool isFavorite;

  ArticleModels({
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory ArticleModels.fromJson(Map<String, dynamic> json) {
    return ArticleModels(
      title: json['title'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
