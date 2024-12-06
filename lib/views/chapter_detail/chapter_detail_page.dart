import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../detail_comic/comic_detail_controller.dart';
import 'chapter_detail_controller.dart';

class ChapterDetailPage extends StatefulWidget {
  const ChapterDetailPage({super.key});

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  final ChapterDetailController controller = Get.put(ChapterDetailController());
  final ComicDetailController comicDetailController =
      Get.put(ComicDetailController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = Get.arguments;
    final chapterApiData = arguments['chapterApiData'];

    // Kiểm tra nếu dữ liệu chương hiện tại khác dữ liệu mới, thì tải dữ liệu mới
    if (controller.chapterPath.value != chapterApiData) {
      controller.fetchChapterDetailData(chapterApiData);
    }

    // Lấy danh sách chương từ `comicDetailController` để gán vào controller
    final selectedServer = comicDetailController.selectedServer;
    final chapters = comicDetailController.comicModel?.chapters
        ?.firstWhere(
          (chapter) => chapter.serverName == selectedServer,
          orElse: () => comicDetailController.comicModel!.chapters![0],
        )
        .chapterData;

    if (chapters != null) {
      controller.chapters.value = chapters; // Gán danh sách chương
      controller.currentChapterIndex.value = chapters.indexWhere(
        (chapter) => chapter.chapterApiData == chapterApiData,
      ); // Xác định index của chương hiện tại
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final chapterName = arguments['chapterName'] ?? '';
    print("arguments: $arguments");
    var orientation = MediaQuery.of(context).orientation;
    print("Orientation: $orientation");
    if (orientation == Orientation.portrait) {
      return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text('Chapter ${controller.chapterName.value}');
          }),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.listImage.isEmpty) {
            return const Center(child: Text('Không có dữ liệu hình ảnh.'));
          }

          return ListView.builder(
            itemCount: controller.listImage.length,
            itemBuilder: (context, index) {
              final item = controller.listImage[index];
              final imageUrl =
                  '${controller.domainCdn.value}/${controller.chapterPath.value}/${item['image_file']}';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 0.01,
                  child: Image.network(
                    imageUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: _buildFloatingActionButton(),
      );
    } else {
      return Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.listImage.isEmpty) {
            return const Center(child: Text('Không có dữ liệu hình ảnh.'));
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: controller.listImage.length,
                itemBuilder: (context, index) {
                  final item = controller.listImage[index];
                  final imageUrl =
                      '${controller.domainCdn.value}/${controller.chapterPath.value}/${item['image_file']}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InteractiveViewer(
                      maxScale: 5.0,
                      minScale: 0.01,
                      child: Image.network(
                        imageUrl,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
              _buildFloatingActionButtonLandscape(),
            ],
          );
        }),
      );
    }
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                // Gọi hàm chuyển về chương trước
                controller.moveToPrevious();
              },
              child: Text(
                "Previous",
                style: TextStyle(fontSize: 16, color: Colors.amber[800]),
              ),
            ),
            TextButton(onPressed: () {
              _showChaptersBottomSheet();
            }, child: Obx(() {
              return Text(
                "Chapter ${controller.chapterName.value}",
                style: TextStyle(fontSize: 18, color: Colors.amber[800]),
              );
            })),
            TextButton(
              onPressed: () {
                // Gọi hàm chuyển sang chương tiếp theo
                controller.moveToNext();
              },
              child: Text(
                "Next",
                style: TextStyle(fontSize: 16, color: Colors.amber[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtonLandscape() {
    return Align(
      alignment: Alignment.centerRight, // Căn bên phải màn hình
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 2, // Tăng chiều cao nút
          width: 80, // Chiều rộng cố định
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Gọi hàm chuyển về chương trước
                    controller.moveToPrevious();
                  },
                  child: Text(
                    "Previous",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.amber[800]),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showChaptersBottomSheet();
                  },
                  child: Obx(() {
                    return Text(
                      "Chapter\n${controller.chapterName.value}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.amber[800]),
                    );
                  }),
                ),
                TextButton(
                  onPressed: () {
                    // Gọi hàm chuyển sang chương tiếp theo
                    controller.moveToNext();
                  },
                  child: Text(
                    "Next",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.amber[800]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChaptersBottomSheet() {
    final controller = Get.find<ChapterDetailController>();

    if (controller.chapters.isEmpty) {
      Get.snackbar('Thông báo', 'Không có chương nào để hiển thị.');
      return;
    }

    // Đồng bộ filteredChapters với chapters trước khi hiển thị
    controller.filteredChapters.assignAll(controller.chapters);

    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.3,
          color: Colors.black54,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text(
              //         'Danh sách chương',
              //         style:
              //             TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //       ),
              //       IconButton(
              //         onPressed: () => Get.back(), // Đóng bottom sheet
              //         icon: const Icon(Icons.close),
              //       ),
              //     ],
              //   ),
              // ),
              // Ô tìm kiếm
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchChapter,
                  decoration: InputDecoration(
                    hintText: 'Search chapter...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final filteredChapters = controller.filteredChapters;

                  if (filteredChapters.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không tìm thấy chương nào.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredChapters.length,
                    itemBuilder: (context, index) {
                      final chapter = filteredChapters[index];
                      return ListTile(
                        title: Text(
                          "Chapter ${chapter.chapterName}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Text(
                          chapter.chapterTitle,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          Get.back(); // Đóng BottomSheet
                          controller.currentChapterIndex.value = controller
                              .chapters
                              .indexOf(chapter); // Cập nhật index
                          controller
                              .fetchChapterDetailData(chapter.chapterApiData);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
