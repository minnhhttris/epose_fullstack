
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl;

  ApiService(this.baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
    _dio.options.validateStatus = (status) {
      // Trả về true cho mã trạng thái từ 200 đến 499 để xử lý các mã trạng thái
      // mà bạn muốn xử lý đặc biệt.
      return status! < 500; // Không ném lỗi cho các mã trạng thái nhỏ hơn 500
    };
  }

  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioError catch (e) {
      print('DioError: ${e.message}');
      throw Exception('Failed to post data: ${e.message}');
    }
  }
}