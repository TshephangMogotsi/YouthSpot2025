class Article {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String authorName;
  final String categoryName;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.authorName,
    required this.categoryName,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageurl'] ?? '',
      authorName: map['authors']['name'] ?? '',
      categoryName: map['categories']['name'] ?? '',
    );
  }
}
