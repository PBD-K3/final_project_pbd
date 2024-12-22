import 'api_service.dart';
import 'package:thousand_flavours/main/models/restaurants.dart';

class RestaurantsApi {
  final ApiService _apiService = ApiService();
  final String _baseUrl = 'andhika-nayaka-athousandflavourmidterm.pbp.cs.ui.ac.id';

  Future<List<Restaurants>> fetchRestaurants() async {
    try {
      final response = await _apiService.get(url: _baseUrl);
      if (response is List) {
        return response.map((json) => Restaurants.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format: Expected a list.');
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      rethrow; 
    }
  }
}
