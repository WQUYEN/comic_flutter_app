import 'package:comic_app_with_getx/views/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchPageController controller = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextField luôn hiển thị
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: controller.searchTextController.value,
              decoration: InputDecoration(
                labelText: 'Search........',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Viền bo tròn
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Viền khi được chọn
                  borderSide: const BorderSide(
                    color: Colors.blue, // Màu viền khi focus
                    width: 2.0,
                  ),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              keyboardType: TextInputType.text,
              onChanged: (text) {
                // Gọi API mỗi khi người dùng thay đổi văn bản
                controller.onSearchTextChanged(text);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Sử dụng Obx để theo dõi trạng thái loading và dữ liệu comics
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.comics.isEmpty) {
              return const Center(child: Text('No comics available.'));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.comics.length,
                  itemBuilder: (context, index) {
                    final comic = controller.comics[index];
                    return ListTile(
                      onTap: () {
                        controller.onComicTapped(comic);
                      },
                      leading: Image.network(
                        comic.thumbUrl != null
                            ? 'https://img.otruyenapi.com/uploads/comics/${comic.thumbUrl}'
                            : 'https://via.placeholder.com/50',
                        width: 50,
                        fit: BoxFit.cover,
                      ), // Hiển thị ảnh truyện
                      title: Text(comic.name),
                      subtitle: Text(comic.content),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
