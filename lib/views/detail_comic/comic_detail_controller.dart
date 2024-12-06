import 'package:comic_app_with_getx/models/chapter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart'; // Import GetX để sử dụng state management và UI tiện ích

import '../../models/comic_model.dart'; // Import model ComicModel
import '../../routes/routes_name.dart';
import '../../services/api_service.dart'; // Import dịch vụ API

class ComicDetailController extends GetxController {
  final ApiService _apiService = ApiService();
  ComicModel? comicModel;
  String? selectedServer;
  var isLoading = false.obs;
  var comicName = ''.obs;
  TextEditingController searchChapterController = TextEditingController();

  /// Phương thức lấy thông tin chi tiết của truyện từ API
  Future<ComicModel?> fetchDetailComic(String slug) async {
    isLoading.value = true;
    try {
      // Gọi API để lấy chi tiết truyện
      final data = await _apiService.get('truyen-tranh/$slug');

      // Xử lý dữ liệu trả về
      if (data['status'] == 'success') {
        final comic = ComicModel.fromJson(data['data']['item']);
        comicModel = comic;
        comicName.value = comic.name;
        // Mặc định chọn server đầu tiên nếu có chapters
        if (comic.chapters?.isNotEmpty == true) {
          selectedServer = comic.chapters![0].serverName;
          // print('Default server: $selectedServer');
        }
        return comic;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch comic details.');
      }
    } catch (e) {
      // Hiển thị thông báo lỗi
      // Get.snackbar('Error', 'Failed to fetch comic: $e');
      return null;
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  // Cập nhật server khi người dùng chọn
  void updateSelectedServer(String serverName) {
    selectedServer = serverName;
    update(); // Cập nhật trạng thái để giao diện thay đổi
    // print('Selected server updated to: $serverName');
  }

  /// Hàm lấy trạng thái của truyện
  String getStatusText(String? status) {
    if (status == null) {
      return 'Không có';
    }
    switch (status) {
      case 'ongoing':
        return 'Đang phát hành';
      case 'coming_soon':
        return 'Sắp phát hành';
      case 'completed':
        return 'Đã hoàn thành';
      default:
        return 'Trạng thái không xác định';
    }
  }

// Hàm để loại bỏ các thẻ HTML
  String stripHtmlTags(String html) {
    final RegExp exp = RegExp(r'<[^>]*>');
    return html.replaceAll(exp, '');
  }

  //Click item list Comics
  void onChapterTapped(Chapter chapter) {
    Get.toNamed(RoutesName.chapterDetailPage,
        arguments: {'chapterApiData': chapter.chapterData});
  }
}
