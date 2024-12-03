import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://otruyenapi.com/v1/api/"; // URL gốc

  // Phương thức POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    return _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      body: body,
    );
  }

  // Phương thức GET
  Future<dynamic> get(String endpoint,
      {Map<String, String>? queryParams}) async {
    return _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      queryParams: queryParams,
    );
  }

  // Phương thức PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    return _sendRequest(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
    );
  }

  // Phương thức PATCH
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    return _sendRequest(
      method: 'PATCH',
      endpoint: endpoint,
      body: body,
    );
  }

  // Phương thức DELETE
  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? body}) async {
    return _sendRequest(
      method: 'DELETE',
      endpoint: endpoint,
      body: body,
    );
  }

  // Hàm chung để gửi request
  Future<dynamic> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    try {
      // Xây dựng URL với query parameters nếu có
      final uri =
          Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);

      // Cấu hình headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Khởi tạo biến phản hồi
      late http.Response response;

      // Gửi request dựa trên HTTP method
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response =
              await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'PUT':
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'PATCH':
          response =
              await http.patch(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri,
              headers: headers, body: body != null ? jsonEncode(body) : null);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse JSON từ phản hồi
        return jsonDecode(response.body);
      } else {
        // Parse lỗi từ phản hồi server nếu có
        final errorMessage = _extractErrorMessage(response);
        throw Exception('HTTP ${response.statusCode}: $errorMessage');
      }
    } catch (e) {
      // Ném lại lỗi để xử lý ở controller
      rethrow;
    }
  }

  // Phương thức GET cho màn hình này (dùng riêng cho ComicDetailPage)
  Future<dynamic> getComicDetailData(String chapterApiData) async {
    try {
      final uri = Uri.parse(chapterApiData);

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body); // Trả về dữ liệu khi thành công
      } else {
        final errorMessage = _extractErrorMessage(response);
        throw Exception('HTTP ${response.statusCode}: $errorMessage');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Trích xuất thông báo lỗi từ phản hồi (nếu có)
String _extractErrorMessage(http.Response response) {
  try {
    final errorData = jsonDecode(response.body);
    if (errorData is Map && errorData.containsKey('message')) {
      return errorData['message'];
    }
    return response.body; // Nếu không có thông báo lỗi cụ thể
  } catch (e) {
    return 'Unknown error: ${response.body}';
  }
}

// Hàm trả về header mặc định
Map<String, String> _headers() {
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
