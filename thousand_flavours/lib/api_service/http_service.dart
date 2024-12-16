import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  Future<dynamic> get({
    required String url,
    required Map<String, String> headers,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to fetch data from $url. Status Code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}
