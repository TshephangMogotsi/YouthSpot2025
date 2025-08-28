class Service {
  final String id;
  final String name;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? locationUrl;
  final String? imageUrl;
  final List<String>? contacts;
  final String? type;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.locationUrl,
    this.imageUrl,
    this.contacts,
    this.type,
    required this.createdAt,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      locationUrl: map['location_url'],
      imageUrl: map['image_url'],
      contacts: map['contacts'] != null ? List<String>.from(map['contacts']) : null,
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
