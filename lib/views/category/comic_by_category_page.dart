import 'package:comic_app_with_getx/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'category_controller.dart';

class ComicByCategoryPage extends StatefulWidget {
  const ComicByCategoryPage({super.key});

  @override
  State<ComicByCategoryPage> createState() => _ComicByCategoryPageState();
}

class _ComicByCategoryPageState extends State<ComicByCategoryPage> {
  final CategoryController controller = Get.put(CategoryController());
  final HomeController homeController = Get.put(HomeController());
  var slug = '';
  var name = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = Get.arguments;
      slug = arguments['category-slug'] ?? '';
      name = arguments['category-name'] ?? '';
      print('ComicByCategoryPage: name $name');
      controller.fetchComicByCategory(controller.currentPage.value, slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('Rebuild ComicByCategoryPage');
    // controller.titlePage.value = name;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Category ${controller.titlePage.value}')),
        leading: IconButton(
            onPressed: () {
              controller.resetCurrentPage();
              controller.resetData();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.comics.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text("Không có truyện nào"),
            ),
          );
        } else {
          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx > 0) {
                // Lướt sang phải (trang trước)
                if (controller.currentPage.value > 1) {
                  controller.goToPrePage(slug);
                  controller.fetchComicByCategory(
                      controller.currentPage.value, slug);
                } else {
                  Get.snackbar('Thông báo', 'Đã ở trang đầu tiên');
                }
              } else {
                // Lướt sang trái (trang sau)
                if (controller.currentPage.value < controller.totalPage.value) {
                  controller.goToNextPage(slug);
                  controller.fetchComicByCategory(
                      controller.currentPage.value, slug);
                } else {
                  Get.snackbar('Thông báo', 'Đã ở trang cuối cùng');
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.comics.length,
                    itemBuilder: (context, index) {
                      final comic = controller.comics[index];
                      return ListTile(
                        onTap: () {
                          // Xử lý khi nhấn vào truyện
                          homeController.onComicTapped(comic);
                        },
                        leading: Image.network(
                          comic.thumbUrl.isNotEmpty
                              ? 'https://img.otruyenapi.com/uploads/comics/${comic.thumbUrl}'
                              : 'https://via.placeholder.com/50',
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(comic.name),
                        subtitle: Text(comic.content),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.goToPrePage(slug);
                          // Thực thi hàm goToPrePage
                        },
                        child: const Text(
                          'Pre',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Trang ${controller.currentPage.value}/${controller.totalPage.value}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller
                              .goToNextPage(slug); // Thực thi hàm goToNextPage
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
