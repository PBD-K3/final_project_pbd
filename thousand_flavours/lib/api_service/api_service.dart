import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'http_service.dart';

class ApiService {
  final HttpService _httpService = HttpService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      'Accept': '*/*'
    };
  }

  Future<dynamic> get({
    required String url,
    Map<String, String>? queryParams,
  }) async {
    final headers = await _getHeaders();
    return _httpService.get(url: url, headers: headers, queryParams: queryParams);
  }
}
