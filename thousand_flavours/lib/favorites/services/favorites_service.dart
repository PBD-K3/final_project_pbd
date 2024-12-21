import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/restaurant_favorites.dart';

class ServiceFavorites {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<List<RestaurantFavorites>> getFavorites(CookieRequest request) async {
    try {
      final response = await request.get('$baseUrl/favorites/');
      if (response is List) {
        return response.map<RestaurantFavorites>((json) => RestaurantFavorites.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  static Future<bool> addToFavorites(
      BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      final csrfResponse = await request.get('$baseUrl/csrf/');
      final csrfToken = csrfResponse['csrfToken'];

      print("CSRF Token: $csrfToken");

      // Add to favorites
      final response = await request.post(
        '$baseUrl/add-to-favorites/$restaurantId/',
        {
          'csrfmiddlewaretoken': csrfToken, 
        },
      );

      print("Add to Favorites Response: $response");

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Added to favorites')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Failed to add to favorites')),
        );
        return false;
      }
    } catch (e) {
      print("Add to favorites error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  static Future<bool> removeFromFavorites(
      BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      final csrfResponse = await request.get('$baseUrl/csrf/');
      final csrfToken = csrfResponse['csrfToken'];

      print("CSRF Token: $csrfToken");

      final response = await request.post(
        '$baseUrl/remove-from-favorites/$restaurantId/',
        {
          'csrfmiddlewaretoken': csrfToken,
        },
      );

      print("Remove from Favorites Response: $response");

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'Removed from favorites')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response['message'] ?? 'Failed to remove from favorites')),
        );
        return false;
      }
    } catch (e) {
      print("Remove from favorites error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }
}
