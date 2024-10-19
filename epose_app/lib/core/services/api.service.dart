import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class ApiService {
  final String baseUrl;
  String? bearerToken; // Biến chứa token
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  ApiService(this.baseUrl, [this.bearerToken]) {
    if (bearerToken != null && bearerToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }
  }

  // Hàm để cập nhật token nếu cần
  void updateToken(String newToken) {
    bearerToken = newToken;
    headers['Authorization'] = 'Bearer $bearerToken';
  }

  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data, {String? accessToken}) async {
    print('$baseUrl$endpoint');

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    
    final response = await http.post(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: json.encode(data));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getData(String endpoint, {String? accessToken}) async {
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response =
        await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> putData(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: json.encode(data));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteData(String endpoint, {String? accessToken}) async {
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final response =
        await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patchData(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.patch(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: json.encode(data));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> postMultipartData(
      String endpoint,
      Map<String, String> fields, 
      List<File> images, 
      {String? accessToken}) async {
    // Tạo request multipart
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));

    // Thêm token nếu có
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Đặt các trường dạng text (ví dụ: nameItem, description,...)
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Thêm danh sách ảnh vào request
    for (var image in images) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'listPicture', // Tên trường ảnh
        stream,
        length,
        filename: image.path.split('/').last, 
        contentType:
            MediaType('image', image.path.endsWith('.png') ? 'png' : 'jpeg'), 
      );
      request.files.add(multipartFile);
       print( 'request.files: ${request.files}');
    }
   

    // Gửi request
    var response = await request.send();
    print('Response: ${response}');

    // Lấy kết quả từ response
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } else {
      print('Failed to upload data: ${response.statusCode}');
      throw Exception('Failed to process data: ${response.statusCode}');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to process data: ${response.statusCode}');
    }
  }
}
