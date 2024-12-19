import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/restaurant_wishlist.dart';
import '../services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  List<RestaurantWishlist> _wishlist = [];
  bool _isLoading = false;

  List<RestaurantWishlist> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  Future<void> fetchWishlist(CookieRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final items = await WishlistService.getWishlist(request);
      _wishlist = items;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> addToWishlist(BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      final success = await WishlistService.addToWishlist(context, request, restaurantId);
      if (success) {
        await fetchWishlist(request);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromWishlist(BuildContext context, CookieRequest request, String restaurantId) async {
    try {
      final success = await WishlistService.removeFromWishlist(context, request, restaurantId);
      if (success) {
        await fetchWishlist(request);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  bool isInWishlist(String restaurantId) {
    return _wishlist.any((item) => item.id == restaurantId);
  }
} 