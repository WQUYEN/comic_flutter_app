import 'chapter_data_model.dart';

class Chapter {
  final String serverName;
  final List<ChapterData> chapterData;

  Chapter({
    required this.serverName,
    required this.chapterData,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      serverName: json['server_name'] ?? '',
      chapterData: (json['server_data'] as List<dynamic>?)
              ?.map((e) => ChapterData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'server_name': serverName ?? '',
      'server_data': chapterData.map((e) => e.toJson()).toList(),
    };
  }
}
