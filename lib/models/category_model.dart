class Category {
  final String id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '', // Handle null case
      name: json['name'] ?? 'Unknown', // Handle null case
      slug: json['slug'] ?? '', // Handle null case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
    };
  }
}
