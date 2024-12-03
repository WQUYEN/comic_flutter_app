class ChapterData {
  final String filename;
  final String chapterName;
  final String chapterTitle;
  final String chapterApiData;

  ChapterData({
    required this.filename,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
  });

  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      filename: json['filename'],
      chapterName: json['chapter_name'],
      chapterTitle: json['chapter_title'],
      chapterApiData: json['chapter_api_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'chapter_name': chapterName,
      'chapter_title': chapterTitle,
      'chapter_api_data': chapterApiData,
    };
  }
}
