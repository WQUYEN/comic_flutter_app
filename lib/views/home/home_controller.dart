import 'package:get/get.dart';

import '../../models/comic_model.dart';
import '../../routes/routes_name.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();

  var comics = <ComicModel>[].obs; // Danh sách truyện
  var isLoading = false.obs; // Trạng thái loading

// Hàm fetch danh sách truyện
  Future<void> fetchComics() async {
    isLoading.value = true; // Bắt đầu loading
    try {
      final response = await apiService.get(
        'home',
        queryParams: {'page': '1'}, // Nếu có tham số query
      );
      // Chuyển đổi dữ liệu nhận được
      final List<ComicModel> fetchedComics = (response['data']['items'] as List)
          .map((item) => ComicModel.fromJson(item))
          .toList();
      comics.value = fetchedComics; // Cập nhật danh sách truyện
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch comics: $e'); // Hiển thị lỗi
      print('Error Failed to fetch comics: $e');
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  //Click item list Comics
  void onComicTapped(ComicModel comic) {
    Get.toNamed(RoutesName.comicDetailPage,
        arguments: {'slug': comic.slug, 'name': comic.name});
  }
}
