class MotivationalQuote {
  final String id;
  final String author;
  final String quote;
  final String backgroundImageUrl;
  final DateTime created;
  final bool isFavorite;

  MotivationalQuote({
    required this.id,
    required this.author,
    required this.quote,
    required this.backgroundImageUrl,
    required this.created,
    this.isFavorite = false,
  });

  // Factory method to create from Supabase response
  factory MotivationalQuote.fromSupabase(Map<String, dynamic> json) {
    return MotivationalQuote(
      id: json['id']?.toString() ?? '',
      author: json['author']?.toString() ?? 'Unknown',
      quote: json['qoute']?.toString() ?? json['quote']?.toString() ?? '', // Handle both spellings
      backgroundImageUrl: json['background_image_url']?.toString() ?? '',
      created: json['created'] != null 
          ? DateTime.parse(json['created'].toString())
          : DateTime.now(),
      isFavorite: false, // Will be set locally
    );
  }

  // Copy method for updating favorite status
  MotivationalQuote copyWith({
    String? id,
    String? author,
    String? quote,
    String? backgroundImageUrl,
    DateTime? created,
    bool? isFavorite,
  }) {
    return MotivationalQuote(
      id: id ?? this.id,
      author: author ?? this.author,
      quote: quote ?? this.quote,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      created: created ?? this.created,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Backward compatibility getters for existing UI
  String get backgroundImage => backgroundImageUrl;
}