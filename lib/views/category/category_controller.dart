import 'package:comic_app_with_getx/models/category_model.dart';
import 'package:get/get.dart';

import '../../models/comic_model.dart';
import '../../routes/routes_name.dart';
import '../../services/api_service.dart';

class CategoryController extends GetxController {
  final ApiService apiService = ApiService();
  var category = <Category>[].obs; // Danh sách truyện
  var isLoading = false.obs; // Trạng thái loading
  var comics = <ComicModel>[].obs; // Danh sách truyện
  var titlePage = ''.obs;
  RxInt currentPage = 1.obs;
  var totalPage = 1.obs;
  var totalItems = 1.obs;
  var totalItemsPerPage = 1.obs;

  Future<void> fetchCategory() async {
    isLoading.value = true; // Bắt đầu loading
    try {
      final response = await apiService.get(
        'the-loai',
        queryParams: {}, // Nếu có tham số query
      );
      // Chuyển đổi dữ liệu nhận được
      final List<Category> fetchCategory = (response['data']['items'] as List)
          .map((item) => Category.fromJson(item))
          .toList();
      category.value = fetchCategory; // Cập nhật danh sách truyện
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch category: $e'); // Hiển thị lỗi
      print('Error Failed to fetch category: $e');
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  Future<void> fetchComicByCategory(int page, String slug) async {
    isLoading.value = true; // Bắt đầu loading
    try {
      final response = await apiService.get(
        'the-loai/$slug',
        queryParams: {'page': '$page'}, // Nếu có tham số query
      );
      // Chuyển đổi dữ liệu nhận được
      final List<ComicModel> fetchedComics = (response['data']['items'] as List)
          .map((item) => ComicModel.fromJson(item))
          .toList();
      totalItems.value = response['data']['params']['pagination']['totalItems'];
      totalItemsPerPage.value =
          response['data']['params']['pagination']['totalItemsPerPage'];

      totalPage.value =
          (totalItems.value / totalItemsPerPage.value).ceil(); // Tính totalPage
      print('totalPage: $totalPage.value');
      titlePage.value = response['data']['titlePage'];
      comics.value = fetchedComics; // Cập nhật danh sách truyện
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch category: $e'); // Hiển thị lỗi
      print('Error Failed to fetch category: $e');
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

// Hàm gọi API để lấy dữ liệu trang trước
  void goToPrePage(slug) {
    if (currentPage.value > 1) {
      currentPage.value--; // Giảm trang xuống 1
      print("fetch comic called, currentPage = $currentPage");
      fetchComicByCategory(currentPage.value, slug);
    } else {
      Get.snackbar('WQ Comic', 'Đã ở trang đầu tiên');
    }
  }

// Hàm gọi API để lấy dữ liệu trang sau
  void goToNextPage(slug) {
    print("fetch comic called, currentPage = $currentPage");
    currentPage.value++; // Tăng trang lên 1
    fetchComicByCategory(currentPage.value, slug);
  }

  //Click item list category
  void onCategoryTapped(Category category) {
    Get.toNamed(RoutesName.comicByCategoryPage, arguments: {
      'category-slug': category.slug,
      'category-name': category.name,
    });
  }

  void resetData() {
    titlePage.value = '';
    comics.clear(); // Xóa danh sách hiện tại
  }

  void resetCurrentPage() {
    currentPage.value = 1; // Đặt lại currentPage về 1
  }
}
