import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gọi API khi HomePage được mở
    controller.fetchComics();
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.comics.isEmpty) {
            return const Center(child: Text('No comics available.'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0), // Thêm khoảng cách
                  child: Text(
                    'Danh sách truyện mới nhất:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Số lượng cột
                      crossAxisSpacing: 20, // Khoảng cách giữa các cột
                      mainAxisSpacing: 20, // Khoảng cách giữa các hàng
                      childAspectRatio:
                          0.6, // Tỉ lệ chiều rộng / chiều cao của mỗi phần tử
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.comics.length,
                    itemBuilder: (context, index) {
                      final comic = controller.comics[index];
                      // Lấy chapter đầu tiên từ chaptersLatest nếu có
                      final firstChapterName = comic.chaptersLatest.isNotEmpty
                          ? comic.chaptersLatest[0].chapterName
                          : 'No chapter available';
                      return GestureDetector(
                        onTap: () {
                          controller.onComicTapped(comic);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                comic.thumbUrl != null
                                    ? 'https://img.otruyenapi.com/uploads/comics/${comic.thumbUrl}'
                                    : 'https://via.placeholder.com/100',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // Chiều rộng full của mỗi phần tử
                                height: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comic.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2, // Giới hạn số dòng của tiêu đề
                              overflow: TextOverflow
                                  .ellipsis, // Hiển thị ... nếu quá dài
                            ),
                            Text(
                              'Chap $firstChapterName',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1, // Giới hạn số dòng
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
        }),
      );
    } else {
      return Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.comics.isEmpty) {
            return const Center(child: Text('No comics available.'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Padding(
                //   padding: EdgeInsets.all(16.0), // Thêm khoảng cách
                //   child: Text(
                //     'Danh sách truyện mới nhất:',
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // Số lượng cột
                      crossAxisSpacing: 20, // Khoảng cách giữa các cột
                      mainAxisSpacing: 20, // Khoảng cách giữa các hàng
                      childAspectRatio:
                          0.6, // Tỉ lệ chiều rộng / chiều cao của mỗi phần tử
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.comics.length,
                    itemBuilder: (context, index) {
                      final comic = controller.comics[index];
                      // Lấy chapter đầu tiên từ chaptersLatest nếu có
                      final firstChapterName = comic.chaptersLatest.isNotEmpty
                          ? comic.chaptersLatest[0].chapterName
                          : 'No chapter available';
                      return GestureDetector(
                        onTap: () {
                          controller.onComicTapped(comic);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                comic.thumbUrl != null
                                    ? 'https://img.otruyenapi.com/uploads/comics/${comic.thumbUrl}'
                                    : 'https://via.placeholder.com/100',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // Chiều rộng full của mỗi phần tử
                                height: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comic.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2, // Giới hạn số dòng của tiêu đề
                              overflow: TextOverflow
                                  .ellipsis, // Hiển thị ... nếu quá dài
                            ),
                            Text(
                              'Chap $firstChapterName',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1, // Giới hạn số dòng
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
        }),
      );
    }
  }
}
