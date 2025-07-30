class ResourceCategory {
  final String id;
  final String name;

  ResourceCategory({required this.id, required this.name});

  factory ResourceCategory.fromMap(Map<String, dynamic> map) {
    return ResourceCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}

class ResourceSubcategory {
  final String id;
  final String name;
  final String categoryId;

  ResourceSubcategory({required this.id, required this.name, required this.categoryId});

  factory ResourceSubcategory.fromMap(Map<String, dynamic> map) {
    return ResourceSubcategory(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
    );
  }
}

class Resource {
  final String id;
  final String name;
  final String? categoryId;
  final String? subcategoryId;
  final String? url;
  final String? fileType;
  final DateTime createdAt;

  Resource({
    required this.id,
    required this.name,
    this.categoryId,
    this.subcategoryId,
    this.url,
    this.fileType,
    required this.createdAt,
  });

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      subcategoryId: map['subcategory_id'],
      url: map['url'],
      fileType: map['file_type'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
