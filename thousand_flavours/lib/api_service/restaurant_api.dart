import 'api_service.dart';
import 'package:thousand_flavours/main/models/restaurants.dart';

class RestaurantsApi {
  final ApiService _apiService = ApiService();
  final String _baseUrl = 'http://localhost:8000/json/';

  Future<List<Restaurants>> fetchRestaurants() async {
    final response = await _apiService.get(url: _baseUrl);
    return (response as List).map((json) => Restaurants.fromJson(json)).toList();
  }
}
