import 'package:get/get.dart';

import '../../models/comic_model.dart';
import '../../services/api_service.dart';

class CompletedComicController extends GetxController {
  final ApiService apiService = ApiService();
  var comicsByPage = <int, List<ComicModel>>{}.obs; // Dữ liệu từng trang
  var comics = <ComicModel>[].obs; // Danh sách truyện
  var isLoading = false.obs; // Trạng thái loading
  RxInt currentPage = 1.obs;
  var totalPage = 1.obs;
  var totalItems = 1.obs;
  var totalItemsPerPage = 1.obs;
//Hàm fetch danh sách truyện
  Future<void> fetchComics(page) async {
    if (comicsByPage[page] != null) return;
    isLoading.value = true; // Bắt đầu loading
    try {
      final response = await apiService.get(
        'danh-sach/hoan-thanh',
        queryParams: {'page': '$page'}, // Nếu có tham số query
      );
      // Chuyển đổi dữ liệu nhận được
      final List<ComicModel> fetchedComics = (response['data']['items'] as List)
          .map((item) => ComicModel.fromJson(item))
          .toList();
      comics.value = fetchedComics; // Cập nhật danh sách truyện
      totalItems.value = response['data']['params']['pagination']['totalItems'];
      totalItemsPerPage.value =
          response['data']['params']['pagination']['totalItemsPerPage'];

      totalPage.value =
          (totalItems.value / totalItemsPerPage.value).ceil(); // Tính totalPage
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch comics: $e'); // Hiển thị lỗi
    } finally {
      isLoading.value = false; // Kết thúc loading
    }

    ;
  }

// Hàm gọi API để lấy dữ liệu trang trước
  void goToPrePage() {
    if (currentPage.value > 1) {
      currentPage.value--; // Giảm trang xuống 1
      print("fetch comic called, currentPage = $currentPage");
      fetchComics(currentPage.value);
    } else {
      Get.snackbar('WQ Comic', 'Đã ở trang đầu tiên');
    }
  }

// Hàm gọi API để lấy dữ liệu trang sau
  void goToNextPage() {
    print("fetch comic called, currentPage = $currentPage");
    currentPage.value++; // Tăng trang lên 1
    fetchComics(currentPage.value);
  }
}
