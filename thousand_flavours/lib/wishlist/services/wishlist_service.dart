import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant_wishlist.dart';

class WishlistService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<List<RestaurantWishlist>> getWishlist(CookieRequest request) async {
    try {
      final response = await request.get('$baseUrl/wishlist/');
      if (response is List) {
        return response.map<RestaurantWishlist>((json) => RestaurantWishlist.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching wishlist: $e');
      return [];
    }
  }

  static Future<bool> addToWishlist(
      BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      // Fetch CSRF token
      final csrfResponse = await request.get('$baseUrl/csrf/');
      final csrfToken = csrfResponse['csrfToken'];

      print("CSRF Token: $csrfToken");

      // Add to wishlist
      final response = await request.post(
        '$baseUrl/add-to-wishlist/$restaurantId/',
        {
          'csrfmiddlewaretoken': csrfToken,//csrfToken ambil dari value login
        },
      );

      print("Add to Wishlist Response: $response");

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Added to wishlist')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Failed to add to wishlist')),
        );
        return false;
      }
    } catch (e) {
      print("Add to wishlist error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  static Future<bool> removeFromWishlist(
      BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      // Fetch CSRF token
      final csrfResponse = await request.get('$baseUrl/csrf/');
      final csrfToken = csrfResponse['csrfToken'];

      print("CSRF Token: $csrfToken");

      // Remove from wishlist using DELETE method
      final response = await request.post(
        '$baseUrl/remove-from-wishlist/$restaurantId/',
        {
          'csrfmiddlewaretoken': csrfToken,
        },
      );

      print("Remove from Wishlist Response: $response");

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'Removed from wishlist')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response['message'] ?? 'Failed to remove from wishlist')),
        );
        return false;
      }
    } catch (e) {
      print("Remove from wishlist error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }
}