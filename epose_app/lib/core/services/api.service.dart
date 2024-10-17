import 'dart:convert';
import 'package:http/http.dart' as http;


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

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to process data: ${response.statusCode}');
    }
  }
}
