class Article {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final String author;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.author,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      category: map['categories']?['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageurl'] ?? '',
      author: map['authors']?['name'] ?? '',
    );
  }
}
