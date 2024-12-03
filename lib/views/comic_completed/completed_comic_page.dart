import 'package:comic_app_with_getx/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'completed_comic_controller.dart';

class CompletedComicPage extends StatefulWidget {
  const CompletedComicPage({super.key});

  @override
  State<CompletedComicPage> createState() => _CompletedComicPageState();
}

class _CompletedComicPageState extends State<CompletedComicPage> {
  final CompletedComicController controller =
      Get.put(CompletedComicController());
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    controller.fetchComics(controller.currentPage.value);
  }

  @override
  Widget build(BuildContext context) {
    // Mỗi lần currentPage thay đổi, fetch lại dữ liệu
    // print("rebuild");
    return Scaffold(body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.comics.isEmpty) {
        return const Center(child: Text('No comics available.'));
      } else {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              // Lướt sang phải (trang trước)
              if (controller.currentPage.value > 1) {
                controller.goToPrePage();
              } else {
                Get.snackbar('Thông báo', 'Đã ở trang đầu tiên');
              }
            } else {
              // Lướt sang trái (trang sau)
              if (controller.currentPage.value < controller.totalPage.value) {
                controller.goToNextPage();
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: controller.comics.length,
                  itemBuilder: (context, index) {
                    final comic = controller.comics[index];
                    return ListTile(
                      onTap: () {
                        homeController.onComicTapped(comic);
                      },
                      leading: Image.network(
                        comic.thumbUrl != null
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
                        controller.goToPrePage();
                        controller.fetchComics(controller.currentPage.value);
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
                        controller.goToNextPage(); // Thực thi hàm goToNextPage
                        controller.fetchComics(controller.currentPage.value);
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
    }));
  }
}
