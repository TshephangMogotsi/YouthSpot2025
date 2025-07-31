class MotivationalQouteFields {
  static final List<String> values = [
    /// Add all fields
    id, quote, author, isFavorite, backgroundImage
  ];

  static const String id = '_id';
  static const String quote = 'quote';
  static const String author = 'author';
  static const String isFavorite = 'isFavorite';
  static const String backgroundImage = 'backgroundImage';

}

class MotivationalQoute {
  final int id;
  final String quote;
  final String author;
  final bool isFavorite;
  final String backgroundImage;

  MotivationalQoute({
    required this.id,
    required this.quote,
    required this.author,
    required this.backgroundImage,
    this.isFavorite = false,
  });

  // Add the copyWith method
  MotivationalQoute copyWith({
    int? id,
    String? quote,
    String? author,
    bool? isFavorite,
    String? backgroundImage,
  }) {
    return MotivationalQoute(
      id: id ?? this.id,
      quote: quote ?? this.quote,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }

  static MotivationalQoute fromJson(Map<String, Object?> json) =>
      MotivationalQoute(
        id: json[MotivationalQouteFields.id] as int,
        author: json[MotivationalQouteFields.author] as String,
        quote: json[MotivationalQouteFields.quote] as String,
        isFavorite: json[MotivationalQouteFields.isFavorite] == 1,
        backgroundImage: json[MotivationalQouteFields.backgroundImage] as String,
      );

  // Add fromSupabase method to handle Supabase data format
  static MotivationalQoute fromSupabase(Map<String, dynamic> json) =>
      MotivationalQoute(
        id: json['id'] as int,
        author: json['author'] as String,
        quote: json['quote'] as String,
        isFavorite: false, // Will be determined locally
        backgroundImage: json['background_image_url'] as String? ?? '',
      );

  Map<String, Object?> toJson() => {
        MotivationalQouteFields.id: id,
        MotivationalQouteFields.quote: quote,
        MotivationalQouteFields.author: author,
        MotivationalQouteFields.isFavorite: isFavorite ? 1 : 0,
      };
}

const String tableFavoriteQoutes = 'favorite_qoutes';

