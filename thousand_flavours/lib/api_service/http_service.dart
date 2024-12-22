import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  Future<dynamic> get({
    required String url,
    required Map<String, String> headers,
    Map<String, String>? queryParams,
  }) async {
    final client = http.Client();
    // Ensure the URL uses http instead of https
    if (url.startsWith('https://')) {
      url = url.replaceFirst('https://', 'http://');
    }
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await client.get(uri, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch data from $url');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      client.close(); // Always close the client
    }
  }
}