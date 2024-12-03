import 'package:comic_app_with_getx/views/category/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCategory();
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.category.isEmpty) {
          return const Center(child: Text('No category available.'));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0), // Thêm khoảng cách
                child: Text(
                  'Danh sách thể loại:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.category.length,
                  itemBuilder: (context, index) {
                    final category = controller.category[index];
                    return ListTile(
                      onTap: () {
                        controller.onCategoryTapped(category);
                      },

                      title: Text(category.name),
                      //subtitle: Text(comic.content),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
