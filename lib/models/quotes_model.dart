class QuotesModelFields {
  static final List<String> values = [
    /// Add all fields
    id, quote, author, isFavorite, backgroundImageUrl
  ];

  static const String id = '_id';
  static const String quote = 'quote';
  static const String author = 'author';
  static const String isFavorite = 'isFavorite';
  static const String backgroundImageUrl = 'backgroundImageUrl';
}

class QuotesModel {
  final int id;
  final String quote;
  final String author;
  final bool isFavorite;
  final String backgroundImageUrl;

  QuotesModel({
    required this.id,
    required this.quote,
    required this.author,
    required this.backgroundImageUrl,
    this.isFavorite = false,
  });

  // Backward compatibility getter
  String get backgroundImage => backgroundImageUrl;

  // Add the copyWith method
  QuotesModel copyWith({
    int? id,
    String? quote,
    String? author,
    bool? isFavorite,
    String? backgroundImageUrl,
  }) {
    return QuotesModel(
      id: id ?? this.id,
      quote: quote ?? this.quote,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
    );
  }

  // Factory method for local database JSON
  static QuotesModel fromJson(Map<String, Object?> json) =>
      QuotesModel(
        id: json[QuotesModelFields.id] as int,
        author: json[QuotesModelFields.author] as String,
        quote: json[QuotesModelFields.quote] as String,
        isFavorite: json[QuotesModelFields.isFavorite] == 1,
        backgroundImageUrl: json[QuotesModelFields.backgroundImageUrl] as String,
      );

  // Factory method to handle Supabase data format
  static QuotesModel fromSupabase(Map<String, dynamic> json) =>
      QuotesModel(
        id: json['id'] as int,
        author: json['author'] as String,
        quote: json['quote'] as String,
        isFavorite: false, // Will be determined locally
        backgroundImageUrl: json['background_image_url'] as String? ?? '',
      );

  // Convert to JSON for local database storage
  Map<String, Object?> toJson() => {
        QuotesModelFields.id: id,
        QuotesModelFields.quote: quote,
        QuotesModelFields.author: author,
        QuotesModelFields.isFavorite: isFavorite ? 1 : 0,
        QuotesModelFields.backgroundImageUrl: backgroundImageUrl,
      };
}

const String tableFavoriteQuotes = 'favorite_quotes';