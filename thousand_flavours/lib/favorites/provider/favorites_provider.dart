import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/restaurant_favorites.dart';
import '../services/favorites_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<RestaurantFavorites> _favorites = [];
  bool _isLoading = false;

  List<RestaurantFavorites> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites(CookieRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final items = await ServiceFavorites.getFavorites(request);
      _favorites = items;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> addToFavorites(BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      final success = await ServiceFavorites.addToFavorites(context, request, restaurantId);
      if (success) {
        await fetchFavorites(request);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromFavorites(BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      final success = await ServiceFavorites.removeFromFavorites(context, request, restaurantId);
      if (success) {
        await fetchFavorites(request);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  bool isInFavorites(String restaurantId) {
    return _favorites.any((item) => item.id == restaurantId);
  }
} 