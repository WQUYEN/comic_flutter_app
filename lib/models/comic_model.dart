import 'category_model.dart';
import 'chapter_data_model.dart';
import 'chapter_model.dart';

class ComicModel {
  final String id;
  final String name;
  final String slug;
  final List<String> originName;
  final String content;
  final String status;
  final String thumbUrl;
  final bool subDocquyen;
  final List<String> author;
  final List<Category> categories;
  final List<Chapter>? chapters;
  final DateTime updatedAt;
  final List<ChapterData> chaptersLatest;
  ComicModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.status,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.author,
    required this.categories,
    required this.chapters,
    required this.updatedAt,
    required this.chaptersLatest,
  });

  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      slug: json['slug'] ?? '',
      originName: List<String>.from(json['origin_name'] ?? []),
      content: json['content'] ?? '',
      status: json['status'] ?? 'Unknown',
      thumbUrl: json['thumb_url'] ?? '',
      subDocquyen: json['sub_docquyen'] ?? false,
      author: List<String>.from(json['author'] ?? []),
      categories: (json['category'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      chaptersLatest: (json['chaptersLatest'] as List<dynamic>?)
              ?.map((e) => ChapterData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // Xử lý như một danh sách // Giá trị mặc định nếu không có `chaptersLatest`
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'origin_name': originName,
      'content': content,
      'status': status,
      'thumb_url': thumbUrl,
      'sub_docquyen': subDocquyen,
      'author': author,
      'category': categories.map((e) => e.toJson()).toList(),
      'chapters': chapters?.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
      'chaptersLatest': chaptersLatest.map((e) => e.toJson()).toList(),
    };
  }
}
