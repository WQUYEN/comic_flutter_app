import 'package:comic_app_with_getx/models/comic_model.dart';
import 'package:comic_app_with_getx/views/detail_comic/comic_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes_name.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage({super.key});

  @override
  State<ComicDetailPage> createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends State<ComicDetailPage> {
  final ComicDetailController controller = Get.put(ComicDetailController());
  final imageBaseUrl = 'https://img.otruyenapi.com/uploads/comics/';

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final slug = arguments['slug'] ?? '';
    final name = arguments['name'] ?? '';
    controller.fetchDetailComic(slug);
    print("Rebuild");
    // Kiểm tra giá trị của slug để đảm bảo nó hợp lệ
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.comicModel != null) {
          final comic = controller.comicModel!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(comic.thumbUrl),
                const SizedBox(height: 8),
                _buildTitleAndAuthor(comic.name, comic.author.toString()),
                const SizedBox(height: 8),
                _buildStatus(comic.status),
                const SizedBox(height: 16),
                _buildDescription(comic.content),
                const SizedBox(height: 16),
                const Text(
                  'Chọn server',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildSelectServerButtons(comic),
                const SizedBox(height: 8),
                _buildChaptersSection(),
                const SizedBox(height: 8),
                _buildChapterList(comic),
              ],
            ),
          );
        }

        return const Center(child: Text('Failed to load comic details.'));
      }),
    );
  }

  Widget _buildImage(String thumbUrl) {
    return Image.network(
      '$imageBaseUrl$thumbUrl',
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2.7,
    );
  }

  Widget _buildTitleAndAuthor(String title, String author) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, // Comic title
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // const SizedBox(height: 8),
        // Text(
        //   'Author: $author', // Author
        //   style: const TextStyle(fontSize: 16),
        // ),
      ],
    );
  }

  Widget _buildStatus(String status) {
    return Text('Trạng thái: ${controller.getStatusText(status)}');
  }

  Widget _buildDescription(String description) {
    final plainText = controller.stripHtmlTags(description);

    return Text(
      plainText, // Description of the comic
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildSelectServerButtons(ComicModel comic) {
    return Row(
      children: comic.chapters!.map((chapter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                controller.selectedServer = chapter.serverName;
              });
            },
            child: Text(chapter.serverName),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChaptersSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Danh sách chương:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: _showChaptersBottomSheet,
          child: const Text(
            "See all >",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterList(ComicModel comic) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: comic.chapters != null && comic.chapters!.isNotEmpty
          ? ListView.builder(
              itemCount: comic.chapters!
                          .firstWhere(
                            (chapter) =>
                                chapter.serverName == controller.selectedServer,
                            orElse: () => comic.chapters![0],
                          )
                          .chapterData
                          .length >
                      10
                  ? 10
                  : comic!.chapters!
                      .firstWhere(
                        (chapter) =>
                            chapter.serverName == controller.selectedServer,
                        orElse: () => comic!.chapters![0],
                      )
                      .chapterData
                      .length,
              itemBuilder: (context, index) {
                final chapterData = comic.chapters!
                    .firstWhere(
                      (chapter) =>
                          chapter.serverName == controller.selectedServer,
                    )
                    .chapterData[index];
                return ListTile(
                  title: Text(
                    "Chapter ${chapterData.chapterName}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chapterData.chapterTitle),
                  onTap: () {
                    Get.toNamed(RoutesName.chapterDetailPage, arguments: {
                      'chapterApiData': chapterData.chapterApiData,
                      'chapterName': chapterData.chapterName,
                    });
                  },
                );
              },
            )
          : const Center(child: Text('Không có chương nào.')),
    );
  }

  void _showChaptersBottomSheet() {
    final selectedServer = controller.selectedServer;
    final chapters = controller.comicModel?.chapters
        ?.firstWhere(
          (chapter) => chapter.serverName == selectedServer,
          orElse: () => controller.comicModel!.chapters![0],
        )
        .chapterData;

    if (chapters == null || chapters.isEmpty) {
      Get.snackbar('Thông báo', 'Không có chương nào để hiển thị.');
      return;
    }
    final reversedChapters = chapters.reversed.toList();

    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20), // All corners rounded
          // ),
          color: Colors.black54,
          child: Column(
            children: [
              // Tiêu đề
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Danh sách chương',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Get.back(), // Đóng bottom sheet
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Danh sách chapter
              Expanded(
                child: ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = reversedChapters[index];
                    return ListTile(
                      title: Text(
                        "Chapter ${chapter.chapterName}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(chapter.chapterTitle ?? ''),
                      onTap: () {
                        // Xử lý khi chọn chapter
                        Get.back(); // Đóng bottom sheet
                        Get.toNamed(RoutesName.chapterDetailPage, arguments: {
                          'chapterApiData': chapter.chapterApiData,
                          'chapterName': chapter.chapterName,
                        });

                        print('Chapter ${chapter.chapterName} selected');
                        // Có thể điều hướng hoặc xử lý tại đây
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true, // Cho phép cuộn trong bottom sheet
    );
  }
}
