class CommunityEvent {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime? endDate;
  final String? location;
  final String? organizer;
  final String? imageUrl;
  final int? maxAttendees;
  final int currentAttendees;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isUserAttending;

  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.endDate,
    this.location,
    this.organizer,
    this.imageUrl,
    this.maxAttendees,
    this.currentAttendees = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.isUserAttending = false,
  });

  factory CommunityEvent.fromJson(Map<String, dynamic> json) {
    // Add validation for required fields
    final id = json['id'] as String?;
    final title = json['title'] as String?;
    final eventDateStr = json['event_date'] as String?;
    final createdAtStr = json['created_at'] as String?;
    final updatedAtStr = json['updated_at'] as String?;

    if (id == null || id.isEmpty) {
      throw ArgumentError('Event ID cannot be null or empty');
    }
    if (title == null || title.isEmpty) {
      throw ArgumentError('Event title cannot be null or empty');
    }
    if (eventDateStr == null || eventDateStr.isEmpty) {
      throw ArgumentError('Event date cannot be null or empty');
    }

    return CommunityEvent(
      id: id,
      title: title,
      description: json['description'] as String? ?? '',
      eventDate: DateTime.parse(eventDateStr),
      endDate: json['end_date'] != null 
        ? DateTime.parse(json['end_date'] as String) 
        : null,
      location: json['location'] as String?,
      organizer: json['organizer'] as String?,
      imageUrl: json['image_url'] as String?,
      maxAttendees: json['max_attendees'] as int?,
      currentAttendees: json['current_attendees'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: createdAtStr != null && createdAtStr.isNotEmpty 
        ? DateTime.parse(createdAtStr)
        : DateTime.now(),
      updatedAt: updatedAtStr != null && updatedAtStr.isNotEmpty 
        ? DateTime.parse(updatedAtStr)
        : DateTime.now(),
      isUserAttending: json['is_user_attending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'location': location,
      'organizer': organizer,
      'image_url': imageUrl,
      'max_attendees': maxAttendees,
      'current_attendees': currentAttendees,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CommunityEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    DateTime? endDate,
    String? location,
    String? organizer,
    String? imageUrl,
    int? maxAttendees,
    int? currentAttendees,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isUserAttending,
  }) {
    return CommunityEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      imageUrl: imageUrl ?? this.imageUrl,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isUserAttending: isUserAttending ?? this.isUserAttending,
    );
  }

  bool get isPastEvent => eventDate.isBefore(DateTime.now());
  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  bool get isFull => maxAttendees != null && currentAttendees >= maxAttendees!;
}