import 'package:comic_app_with_getx/models/chapter_data_model.dart';
import 'package:comic_app_with_getx/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChapterDetailController extends GetxController {
  var domainCdn = ''.obs;
  var chapterPath = ''.obs;
  var listImage = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;
  var chapterName = ''.obs;
  final ApiService apiService = ApiService();
  var currentChapterIndex = 0.obs;
  var chapters = <ChapterData>[].obs;
  var filteredChapters = <ChapterData>[].obs; // Danh sách chương đã lọc
  final searchController =
      TextEditingController(); // Bộ điều khiển cho TextField
  @override
  void onInit() {
    super.onInit();
    chapters.listen((value) {
      filteredChapters.assignAll(value); // Hiển thị toàn bộ chapters ban đầu
    });
  }

  Future<void> fetchChapterDetailData(String chapterApiData) async {
    try {
      isLoading.value = true; // Bắt đầu trạng thái loading

      // Gọi API từ ApiService với endpoint riêng biệt
      final data = await apiService
          .getComicDetailData(chapterApiData); // Thay thế bằng endpoint của bạn

      print('Dữ liệu nhận được: $data'); // Kiểm tra dữ liệu nhận được

      // Kiểm tra trạng thái của response
      if (data['status'] == 'success') {
        // Lưu dữ liệu vào các biến Rx
        domainCdn.value = data['data']['domain_cdn'];
        chapterName.value = data['data']['item']['chapter_name'];
        chapterPath.value =
            data['data']['item']['chapter_path']; // Lấy chapter_path
        listImage.value = List<Map<String, dynamic>>.from(
            data['data']['item']['chapter_image']);
        errorMessage.value = ''; // Đặt lại thông điệp lỗi nếu thành công
      } else {
        errorMessage.value = 'Dữ liệu không hợp lệ';
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      errorMessage.value = 'Không thể tải dữ liệu';
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false; // Kết thúc trạng thái loading
    }
  }

  // Hàm chuyển đến chương trước
  void moveToPrevious() {
    if (currentChapterIndex.value > 0) {
      currentChapterIndex.value--;
      final previousChapter = chapters[currentChapterIndex.value];
      fetchChapterDetailData(previousChapter.chapterApiData);
      print('currentChapterIndex: $currentChapterIndex.value');
    } else {
      print('currentChapterIndex: $currentChapterIndex.value');
    }
  }

  // Hàm chuyển đến chương sau
  void moveToNext() {
    if (currentChapterIndex.value < chapters.length - 1) {
      currentChapterIndex.value++;
      final nextChapter = chapters[currentChapterIndex.value];
      fetchChapterDetailData(nextChapter.chapterApiData);
      print('currentChapterIndex: $currentChapterIndex.value');
    } else {
      print('currentChapterIndex: $currentChapterIndex.value');
    }
  }

  void searchChapter(String query) {
    if (query.isEmpty) {
      filteredChapters.assignAll(chapters); // Hiển thị toàn bộ chapters
    } else {
      filteredChapters.assignAll(
        chapters.where((chapter) =>
            chapter.chapterName.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
