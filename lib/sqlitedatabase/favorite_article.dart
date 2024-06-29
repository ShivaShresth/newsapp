class FavoriteArticle {
  final int? id;
  final String url;
  final String title;
  final String description;
  final String urlToImage;

  FavoriteArticle({
    this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.urlToImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
    };
  }

  factory FavoriteArticle.fromMap(Map<String, dynamic> map) {
    return FavoriteArticle(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      description: map['description'],
      urlToImage: map['urlToImage'],
    );
  }

  FavoriteArticle copy({
    int? id,
    String? url,
    String? title,
    String? description,
    String? urlToImage,
  }) {
    return FavoriteArticle(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      urlToImage: urlToImage ?? this.urlToImage,
    );
  }
}
