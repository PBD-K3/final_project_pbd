import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/favorites.dart';

class ServiceFavorites {
  final CookieRequest request;

  ServiceFavorites(this.request);

  // Fetch favorite for a user
  Future<List<Favorites>> fetchFavorites(String userId) async {
    final response = await request.get(
      'http://localhost:8000/favorites/api/view-favorites-flutter/$userId/',
    );

    print("Fetch Favorites Response: $response");

    if (response is List) {
      return response.map<Favorites>((json) => Favorites.fromJson(json)).toList();
    } else {
      print("Error fetching favorites: $response");
      return [];
    }
  }

  // Add restaurant to favorites
  Future<bool> addFavorite(String restaurantId) async {
    final response = await request.post(
      'http://localhost:8000/favorites/api/add-to-favorites-flutter/$restaurantId/',
      {},
    );

    print("Add Favorite Response: $response");

    return response['success'] == true;
  }

  // Remove restaurant from favorites
  Future<bool> removeFavorite(String restaurantId) async {
    final response = await request.post(
      'http://localhost:8000/favorites/api/remove-from-favorites-flutter/$restaurantId/',
      {},
    );

    print("Remove Favorite Response: $response");

    return response['success'] == true;
  }

  // Fetch restaurant details (if needed)
  Future<Restaurants> fetchRestaurantDetails(String pk) async {
    final response = await request.get(
      'http://localhost:8000/restaurants/api/get-details/$pk/',
    );

    print("Fetch Restaurant Details Response: $response");

    if (response != null) {
      return Restaurants.fromJson(response);
    } else {
      throw Exception("Failed to load restaurant details");
    }
  }
}