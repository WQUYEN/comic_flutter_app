import 'package:comic_app_with_getx/models/comic_model.dart';
import 'package:comic_app_with_getx/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/routes_name.dart';

class SearchPageController extends GetxController {
  final ApiService apiService = ApiService();
  final searchTextController = TextEditingController().obs;

  var comics = <ComicModel>[].obs;
  var isLoading = false.obs;

  Future<void> onSearchTextChanged(String text) async {
    isLoading.value = true; // Bắt đầu loading

    try {
      // Sửa lại cách truyền 'searchTextController.text' thay vì 'searchTextController.value'
      final response =
          await apiService.get('tim-kiem', queryParams: {'keyword': text});
      final List<ComicModel> fetchedComics = (response['data']['items'] as List)
          .map((item) => ComicModel.fromJson(item))
          .toList();
      comics.value = fetchedComics; // Cập nhật danh sách truyện
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch comics: $e'); // Hiển thị lỗi
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  //Click item list Comics
  void onComicTapped(ComicModel comic) {
    Get.toNamed(RoutesName.comicDetailPage, arguments: {'slug': comic.slug});
  }
}
